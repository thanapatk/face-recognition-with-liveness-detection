import os
import sys
import pickle
import pandas as pd
import time
import re
from tqdm import tqdm
from collections import Counter
from deepface import DeepFace
from deepface.commons import functions, distance as dst 

# Set up global variables
model = None
input_shape = (224,224) 
threshold = None
df = None 

def startDeepFace(db_path, model_name, distance_metric):
	"""Initializing necessary variables"""

	global model, input_shape, threshold, df

	#region get students pic path
	students = []
	if os.path.isdir(db_path):
		for r,_,f in os.walk(db_path): # root, directories, files
			for file in f:
				if '.jpg' in file:					
					exact_path = r + '/' + file
					students.append(exact_path)
	
	if len(students) == 0:
		print(f'WARNING: There is no image in this path ( {db_path} ). Face Recognition will not be performed', file=sys.stderr, flush=True)
		exit()
	else:
		# Building the face recognition model
		model = DeepFace.build_model(model_name)
		print(f'Using {model_name} model')

		# Get the input shape
		input_shape = functions.find_input_shape(model)

		# Get the threshold for the distance_metric
		threshold = dst.findThreshold(model_name, distance_metric)
	#endregion

	#-----------------------------
	# Find the embeddings for students list

	#region find embeddings
	tic = time.time()

	file_name = f"embeddings_{model_name}.pkl".replace('-','_').lower()

	if os.path.exists(db_path+'/'+file_name):
		print(f'INFO: Using saved embeddings [{db_path}/{file_name}]. If you added new instances, please delete this file and call this again.')

		with open(f'{db_path}/{file_name}', 'rb') as f:
			embeddings = pickle.load(f)

		print(f'INFO: There are {len(embeddings)} embeddings in {file_name}')
	else:
		embeddings = create_embeddings_file(students, input_shape, model)
		with open(f'{db_path}/{file_name}', 'wb') as f:
			pickle.dump(embeddings, f)
		
		print(f'INFO: Embeddings stored in {db_path}/{file_name}. Please delete this file when you add new indentities to your database')
	
	df = pd.DataFrame(embeddings, columns = ['student', 'embedding'])
	df['distance_metric'] = distance_metric

	if df.shape[0] == 0: # No face found in embeddings
		print(f'ERROR: No face found in {db_path}! Exiting...', file=sys.stderr, flush=True)
		exit()

	toc = time.time()

	print(f'INFO: Embeddings found for given data in {toc-tic} seconds')
	#endregion
	#return model, input_shape, threshold, df

def recognition(faces):
	"""Recognition function to be used in threading"""

	global model, input_shape, threshold, df
	
	tic = time.time()
	names = []
	for detected_face in faces:
		# Preprocess the face for finding representation
		custom_face = functions.preprocess_face(img = detected_face, target_size = (input_shape[1], input_shape[0]), enforce_detection = False)

		if custom_face.shape[1:3] == input_shape:
			img1_representation = model.predict(custom_face)[0,:]

			df['distance'] = df.apply(findDistance, axis = 1, img1_representation = img1_representation)
			df = df.sort_values(by = ['distance'])
			
			for i in range(2):
				candidate = df.iloc[i]
				student_name = candidate['student']
				best_distance = candidate['distance']
				#print(student_name)

				if best_distance <= threshold:
					label = re.search(r'^.*-(\d{6})' ,student_name.split('/')[-1]).group(1)
					#label = student_name.split('/')[-1].replace('.jpg', '') + ' ' + str(best_distance)
					names.append(label)
	c = Counter(names)
	output = c.most_common(1)[0][0]
	return output, time.time() - tic

def findDistance(row, img1_representation):
	distance_metric = row['distance_metric']
	img2_representation = row['embedding']

	distance = 1000 #start of at very large value
	if distance_metric == 'cosine':
		distance = dst.findCosineDistance(img1_representation, img2_representation)
	elif distance_metric == 'euclidean':
		distance = dst.findEuclideanDistance(img1_representation, img2_representation)
	elif distance_metric == 'euclidean_l2':
		distance = dst.findEuclideanDistance(dst.l2_normalize(img1_representation), dst.l2_normalize(img2_representation))

	return distance

def create_embeddings_file(students, input_shape, model):
	embeddings = []
	pbar = tqdm(students, desc="Finding embeddings")
	for student in pbar:
		pbar.set_description(f'Finding embedding for {student.split("/")[-1]}')

		# Find the representation
		img = functions.preprocess_face(img = student, target_size = input_shape[::-1], enforce_detection = False)
		img_representation = model.predict(img)[0,:]

		# Add to embeddings
		embeddings.append([student, img_representation])
	return embeddings