import numpy as np
import cv2
import dlib
import time
from firebase_admin import credentials, initialize_app
import pyrealsense2 as rs
import concurrent.futures # threading
from datetime import datetime, timezone

# Local file
from utils.user_card import addUserCard, cornerRadius
from utils.face_recognition.face import startDeepFace, recognition
from utils.liveness.liveness import validate_face
from utils.firebase.firestore import FirestoreClient

machine_id = "Z4odZZCGp52ok8LrFifD"

def check_face(box, img) -> bool:
	shape = img.shape
	return box.left() > 0 and box.right() < shape[1] and box.top() > 0 and box.bottom() < shape[0]

def main(db_path, model_name, distance_metric, face_frame=5):
	"""Main function to run this program"""

	#region predefined
	identity = None; raw_image = None
	have_face = False
	current_faces = []
	face_included_frames = 0

	bg_color = (255, 255, 255)
	fg_color = (0,0,0)

	card_top_left = (100, 350)
	card_bottom_right = (540, 480)

	alpha_animate_frame = 3
	card_animate_frame = 5
	fps = 30
	
	max_alpha = 1
	min_alpha = .57
	alpha = max_alpha
	alpha_animate_amount = (max_alpha - min_alpha) / alpha_animate_frame

	card_max = card_bottom_right[1]
	card_min = card_top_left[1]
	card_height = card_max
	card_animate_amount = (card_max - card_min) / card_animate_frame
	
	font_path = 'fonts/Kanit-Light.ttf'
	font_size = 24

	# set the delay between each scan (in seconds)
	delay = 5
	prev_time = 0

	size = (640,480)
	#endregion

	#region Firebase setup
	cert = 'config/scan-face.json'

	cred = credentials.Certificate(cert=cert)
	app = initialize_app(cred, {'storageBucket': 'scan-face-49afb.appspot.com'})

	firestore = FirestoreClient(app)
	#endregion

	# Initialize the model
	startDeepFace(db_path, model_name, distance_metric)

	#region Camera config
	pipeline = rs.pipeline()
	config = rs.config()

	# Enabling realsense cam
	config.enable_stream(rs.stream.color, size[0], size[1], rs.format.bgr8, fps)
	config.enable_stream(rs.stream.depth, size[0], size[1], rs.format.z16, fps)
	profile = pipeline.start(config)

	depth_sensor = profile.get_device().first_depth_sensor()
	color_sensor = profile.get_device().first_color_sensor()

	# Configure color sensor
	color_sensor.set_option(rs.option.backlight_compensation, 1)
	color_sensor.set_option(rs.option.gamma, 500)

	# Getting the depth sensor's depth scale
	depth_scale = depth_sensor.get_depth_scale()
	print("Depth scale is: ", depth_scale)

	align = rs.align(rs.stream.color)

	detector = dlib.get_frontal_face_detector()
	predictor = dlib.shape_predictor("utils/liveness/shape_predictor_68_face_landmarks.dat")
	#endregion

	#region threading
	executor = concurrent.futures.ThreadPoolExecutor(max_workers=4)

	def callback(future):
		"Callback function for threading"

		nonlocal identity, raw_image
		output, time = future.result()
		utc_now = datetime.now(tz=timezone.utc)
		
		identity = {'identity': output, 'time': utc_now.astimezone(), 'machine': machine_id}
		#firestore.update(output, now, raw_image)
		executor.submit(lambda p: firestore.update(*p), [output, utc_now, raw_image])
	#endregion

	try:
		while True:
			frames = pipeline.wait_for_frames()

			# Align the depth frame to color frame
			aligned_frames = align.process(frames)

			depth_frame = aligned_frames.get_depth_frame()
			color_frame = aligned_frames.get_color_frame()

			# Validate both frames
			if not depth_frame or not color_frame:
				continue

			color_image = np.asanyarray(color_frame.get_data())
			raw_image = color_image.copy()
			
			# Face Detection
			faces = detector(color_image)

			can_scan = time.time() - prev_time > delay

			if len(faces) == 1 and can_scan:
				box = faces[0]
				shape = color_image.shape
				l,r,t,b = box.left(), box.right(), box.top(), box.bottom()
				if r - l > 130 and check_face(box, color_image):
					# Liveness detection
					landmark = predictor(color_image, box)
					is_real_face = validate_face(depth_frame, depth_scale, landmark)

					# Draw box around image
					_box_color = is_real_face and (0,255,0) or (0,0,255) 
					cv2.rectangle(color_image, (l,t), (r,b), _box_color, 1)

					if is_real_face and face_included_frames < face_frame:
						detected_face = color_image[t:b, l:r]

						current_faces.append(detected_face)
						face_included_frames += 1
			elif len(faces) != 1:
				face_included_frames = 0
				have_face = False
				current_faces = []
				
				if identity != None:
					_prev_time = time.time()
					_current_time = _prev_time
					card_height = card_min
					while _current_time - _prev_time <= delay:
						_frames = pipeline.wait_for_frames()
						_color_frame = _frames.get_color_frame()
						_color_image = np.asanyarray(_color_frame.get_data())
						
						# animate alpha
						if _current_time - _prev_time > delay - alpha_animate_frame * 1/fps:
							alpha += alpha < max_alpha and alpha_animate_amount
						
						#animate card
						if _current_time - _prev_time > delay - card_animate_frame * 1/fps:
							card_height += card_height < card_max and card_animate_amount

						_color_image = addUserCard(_color_image, alpha, card_height, card_top_left, card_bottom_right, bg_color, fg_color, identity['identity'], identity['time'], font_path, font_size)

						cv2.imshow('frame', _color_image)
						if cv2.waitKey(1) & 0xFF == ord('q'):
							break

						_current_time = time.time()

					identity = None
					continue
					
			if identity != None:
				#TODO: animate alpha and position
				alpha -= alpha > min_alpha and alpha_animate_amount
				card_height -= card_height > card_min and card_animate_amount

				#cv2.putText(color_image, identity['identity'], (l,t), cv2.FONT_HERSHEY_SIMPLEX, 0.5, text_color, 1)
				color_image = addUserCard(color_image, alpha, card_height, card_top_left, card_bottom_right, bg_color, fg_color, identity['identity'], identity['time'], font_path, font_size)

			# Face recognition
			if face_included_frames >= face_frame and not have_face:
				future = executor.submit(recognition, current_faces)
				future.add_done_callback(callback)
				have_face = True 

			cv2.imshow('frame', color_image)

			if cv2.waitKey(1) & 0xFF == ord('q'):
				break
	except Exception as e:
		print(e)
	finally:
		cv2.destroyAllWindows()
		pipeline.stop()
	
if __name__ == '__main__':
	main('db', 'VGG-Face', 'cosine', face_frame=10)