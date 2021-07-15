import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta

cert = 'config/scan-face.json'

cred = credentials.Certificate(cert=cert)
firebase_admin.initialize_app(cred)

db = firestore.client()

col_ref = db.collection('log')

def update(identity: str):
	"Update the firestore database"
	doc_ref = col_ref.document(identity)

	# get the lastest time of this user
	_prev_data = doc_ref.get().to_dict()['time'][-1]
	_prev = datetime.fromtimestamp(_prev_data.timestamp())
	
	_now = datetime.utcnow()

	# If the user scan face again before 45 mins(1 class),
	# delete the replace the record with this (he might left and be late for class)
	if _now - _prev < timedelta(minutes=45):
		doc_ref.update({
			'time': firestore.ArrayRemove([_prev_data['time'][-1]])
		})

	doc_ref.set({
		'time': firestore.ArrayUnion([_now])
	}, merge=True)
