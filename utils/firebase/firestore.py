from __future__ import annotations # use python3.9 annotations
import numpy as np
from datetime import datetime, timedelta

from firebase_admin import firestore
from utils.firebase.storage import StorageBucket

class FirestoreClient():
	def __init__(self, app) -> None:
		self.db = firestore.client(app)
		self.__bucket = StorageBucket(app)
		self.__col_ref = self.db.collection('log')
	
	def __getFilename(dt: datetime, identity: str) -> tuple[str, str]:
		"""Generate filename from datetime object"""
		foldername = dt.strftime('%Y%m')
		filename = f"{dt.strftime('%Y%m%d%H%M%S')}-{identity}"
		return foldername, filename

	def update(self, identity: str, now: datetime, image: np.ndarray) -> None:
		"Update the firestore database"
		doc_ref = self.__col_ref.document(identity)

		# get the lastest time of this user
		_get = doc_ref.get()
		if _get.exists:
			_prev_data = _get.to_dict()['time'][-1]
			_prev = datetime.fromtimestamp(_prev_data.timestamp())

			# If the user scan face again before 45 mins(1 class),
			# delete the replace the record with this (he might left and be late for class)
			if now - _prev < timedelta(minutes=45):
				_prev_foldername, _prev_filename = self.__getFilename(_prev, identity)

				self.__bucket.delete_file(f"{_prev_foldername}/{_prev_filename}.jpg")

				doc_ref.update({
					'time': firestore.ArrayRemove([_prev])
				})

		foldername, filename = self.__getFilename(now, identity)

		self.__bucket.upload_bytes(image, f'{foldername}/{filename}.jpg')

		# Use set with merge instead of merge in case of new document
		doc_ref.set({
			'time': firestore.ArrayUnion([now])
		}, merge=True)

	
