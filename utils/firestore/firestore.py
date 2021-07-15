import firebase_admin
from firebase_admin import credentials, firestore
import datetime

cert = 'config/scan-face.json'

cred = credentials.Certificate(cert=cert)
firebase_admin.initialize_app(cred)

db = firestore.client()

col_ref = db.collection('log')

def update(identity: str):
	doc_ref = col_ref.document(identity)
	doc_ref.set({
		'time': firestore.ArrayUnion([datetime.datetime.utcnow()])
	}, merge=True)