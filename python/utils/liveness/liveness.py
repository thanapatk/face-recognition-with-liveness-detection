# Import necesary libraries
from typing import Any
import numpy as np
from .markup_68 import markup_68

def find_depth_from(frame, depth_scale, landmark, markup_from, markup_to) -> Any:
	"Return a average depth value of the specific element"
	data = np.asanyarray(frame.get_data())

	average_depth = 0
	n_points = 0
	for i in range(markup_from.value, markup_to.value + 1):
		pt = landmark.part(i)
		depth_in_pixels = data[pt.y, pt.x].astype(float)
		if not depth_in_pixels:
			continue
		average_depth += depth_in_pixels * depth_scale
		n_points += 1
	if n_points == 0:
		# Default value has to be very high, beacuase most algorithm uses min()
		return 100, False
	return average_depth / n_points, True

def validate_face(frame, depth_scale, landmark) -> bool:	
	"""Validate the face if it's real or not using depth data"""
	# Collect all the depth information for the different facial parts
	
	# For the ears, only one may be visible -- we take the closer one
	right_ear_depth, right_ear_found = find_depth_from(frame, depth_scale, landmark, markup_68.RIGHT_EAR, markup_68.RIGHT_1)
	left_ear_depth, left_ear_found = find_depth_from(frame, depth_scale, landmark, markup_68.LEFT_1, markup_68.LEFT_EAR)
	if ((not right_ear_found) and (not left_ear_found)):
		return False
	ear_depth = min(right_ear_depth, left_ear_depth)

	chin_depth, chin_found = find_depth_from(frame, depth_scale, landmark, markup_68.CHIN_FROM, markup_68.CHIN_TO)
	if not chin_found:
		return False
	
	nose_depth, nose_found = find_depth_from(frame, depth_scale, landmark, markup_68.NOSE_RIDGE_2, markup_68.NOSE_TIP)
	if not nose_found:
		return False
	
	right_eye_depth, right_eye_found = find_depth_from(frame, depth_scale, landmark, markup_68.RIGHT_EYE_FROM, markup_68.RIGHT_EYE_TO)
	if not right_eye_found:
		return False
	
	left_eye_depth, left_eye_found = find_depth_from(frame, depth_scale, landmark, markup_68.LEFT_EYE_FROM, markup_68.LEFT_EYE_TO)
	if not left_eye_found:
		return False
	eye_depth = min(left_eye_depth, right_eye_depth)
	
	mouth_depth, mouth_found = find_depth_from(frame, depth_scale, landmark, markup_68.MOUTH_OUTER_FROM, markup_68.MOUTH_INNER_TO)
	if not mouth_found:
		return False

	"""
	Using simple heuristics to determine whether the depth information agrees with what's wxpected:
	such as the nose tip should be closer to the camera than the eyes

	These heuristics are fairly basic but nonetheless serve to illustrate the point that depth data can
	effectively be used to distinguish between a person and a picture of a person
	"""

	if nose_depth >= eye_depth:
		return False
	if eye_depth - nose_depth > 0.07:
		return False
	if ear_depth <= eye_depth:
		return False
	if mouth_depth <= nose_depth:
		return False
	if mouth_depth > chin_depth:
		return False

	"""
	All the distances, collectively, should not span a range that makes no sense,
	I.E. if the face accounts for more than 20cm of depth, or less than 2 cm, then
	something's not right
	"""
	x = max(nose_depth, eye_depth, ear_depth, mouth_depth, chin_depth)
	n = min(nose_depth, eye_depth, ear_depth, mouth_depth, chin_depth)
	if x - n > 0.20:
		return False
	if x - n < 0.02:
		return False
	
	# If everything is not catch till this point, this face should be real
	return True