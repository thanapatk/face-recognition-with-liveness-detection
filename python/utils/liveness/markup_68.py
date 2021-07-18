from enum import Enum

# because auto() from enum starts from 1
counter = 0
def auto():
	global counter
	counter += 1
	return counter - 1 

# Translated directly from C++
class markup_68(Enum):
	"""Enumerate of all the indexes of shape_predictor_68_face_landmarks.dat"""
	# Starting with right ear/the jaw [1-17]
	RIGHT_EAR = JAW_FROM = RIGHT_JAW_FROM = auto()
	RIGHT_1 = auto(); RIGHT_2 = auto(); RIGHT_3 = auto(); RIGHT_4 = auto(); RIGHT_5 = auto(); RIGHT_6 = auto(); RIGHT_7 = RIGHT_JAW_TO = auto()
	CHIN = auto(); CHIN_FROM = CHIN - 1; CHIN_TO = CHIN + 1
	LEFT_7 = auto(); LEFT_JAW_FROM = LEFT_7; LEFT_6 = auto(); LEFT_5 = auto(); LEFT_4 = auto(); LEFT_3 = auto(); LEFT_2 = auto(); LEFT_1 = auto()
	LEFT_EAR = auto(); LEFT_JAW_TO = LEFT_EAR; JAW_TO = LEFT_EAR

	# Eyebrows [18-22] and [23-27]
	RIGHT_EYEBROW_R = auto(); RIGHT_EYEBROW_FROM = RIGHT_EYEBROW_R; RIGHT_EYEBROW_1 = auto(); RIGHT_EYEBROW_2 = auto(); RIGHT_EYEBROW_3 = auto(); RIGHT_EYEBROW_L = auto(); RIGHT_EYEBROW_TO = RIGHT_EYEBROW_L
	LEFT_EYEBROW_R = auto(); LEFT_EYEBROW_FROM = LEFT_EYEBROW_R; LEFT_EYEBROW_1 = auto(); LEFT_EYEBROW_2 = auto(); LEFT_EYEBROW_3 = auto(); LEFT_EYEBROW_L = auto(); LEFT_EYEBROW_TO = LEFT_EYEBROW_L

	# Nose [28-36]
	NOSE_RIDGE_TOP = auto(); NOSE_RIDGE_FROM = NOSE_RIDGE_TOP; NOSE_RIDGE_1 = auto(); NOSE_RIDGE_2 = auto(); NOSE_TIP = auto(); NOSE_RIDGE_TO = NOSE_TIP
	NOSE_BOTTOM_R = auto(); NOSE_BOTTOM_FROM = NOSE_BOTTOM_R; NOSE_BOTTOM_1 = auto(); NOSE_BOTTOM_2 = auto(); NOSE_BOTTOM_3 = auto(); NOSE_BOTTOM_L = auto(); NOSE_BOTTOM_TO = NOSE_BOTTOM_L

	# Eyes [37-42] and [43-48]
	RIGHT_EYE_R = auto(); RIGHT_EYE_FROM = RIGHT_EYE_R; RIGHT_EYE_1 = auto(); RIGHT_EYE_2 = auto(); RIGHT_EYE_L = auto(); RIGHT_EYE_4 = auto(); RIGHT_EYE_5 = auto(); RIGHT_EYE_TO = RIGHT_EYE_5
	LEFT_EYE_R = auto(); LEFT_EYE_FROM = LEFT_EYE_R; LEFT_EYE_1 = auto(); LEFT_EYE_2 = auto(); LEFT_EYE_L = auto(); LEFT_EYE_4 = auto(); LEFT_EYE_5 = auto(); LEFT_EYE_TO = LEFT_EYE_5

	# Mouth [49-68]
	MOUTH_R = auto(); MOUTH_OUTER_R = MOUTH_R; MOUTH_OUTER_FROM = MOUTH_OUTER_R; MOUTH_OUTER_1 = auto(); MOUTH_OUTER_2 = auto(); MOUTH_OUTER_TOP = auto(); MOUTH_OUTER_4 = auto(); MOUTH_OUTER_5 = auto()
	MOUTH_L = auto(); MOUTH_OUTER_L = MOUTH_L; MOUTH_OUTER_7 = auto(); MOUTH_OUTER_8 = auto(); MOUTH_OUTER_BOTTOM = auto(); MOUTH_OUTER_10 = auto(); MOUTH_OUTER_11 = auto(); MOUTH_OUTER_TO = MOUTH_OUTER_11
	MOUTH_INNER_R = auto(); MOUTH_INNER_FROM = MOUTH_INNER_R; MOUTH_INNER_1 = auto(); MOUTH_INNER_TOP = auto(); MOUTH_INNER_3 = auto()
	MOUTH_INNER_L = auto(); MOUTH_INNER_5 = auto(); MOUTH_INNER_BOTTOM = auto(); MOUTH_INNER_7 = auto(); MOUTH_INNER_TO = MOUTH_INNER_7

	N_POINTS = auto()