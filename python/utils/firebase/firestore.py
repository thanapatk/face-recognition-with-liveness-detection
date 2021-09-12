from __future__ import annotations # use python3.9 annotations
import numpy as np
from datetime import datetime, timedelta, timezone

from firebase_admin import firestore
from utils.firebase.storage import StorageBucket

class FirestoreClient():
	def __init__(self, app) -> None:
		self.db = firestore.client(app)
		self.__bucket = StorageBucket(app)
		self.__col_ref = self.db.collection('logs')
	
	def __getFilename(self, dt: datetime, identity: str) -> tuple[str, str]:
		"""Generate filename from datetime object"""
		foldername = dt.strftime('%Y%m')
		filename = f"{dt.strftime('%Y%m%d%H%M%S')}-{identity}"
		return foldername, filename

	def update(self, identity: str, now: datetime, machine_id: str, image: np.ndarray) -> None:
		"Update the firestore database"
		timestamp = str(now.timestamp() * 1000).split('.')[0]
		doc_ref = self.__col_ref.document(timestamp)

		foldername, filename = self.__getFilename(now, identity)

		self.__bucket.upload_bytes(image, f'{foldername}/{filename}.jpg')

		# Use set with merge instead of merge in case of new document
		doc_ref.set({'sid': identity, 'timestamp': int(timestamp), 'machine': machine_id})

	
