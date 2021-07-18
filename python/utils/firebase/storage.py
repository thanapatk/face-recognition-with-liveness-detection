import cv2
import numpy as np

from firebase_admin import App, storage

class StorageBucket():
	def __init__(self, app: App) -> None:
		self.bucket = storage.bucket(app=app)
	
	def upload_bytes(self, source: np.ndarray, destination_blob_name: str) -> None:
		"""Upload image bytes to the storage bucket and return the uri of the image"""	
		try:
			blob = self.bucket.blob(destination_blob_name)
			
			_, source_bytes = cv2.imencode('.jpg', source)

			blob.upload_from_string(source_bytes.tobytes(), content_type='image/jpeg')
			blob.make_public()
		except Exception as e:
			print(e)

	def delete_file(self, destination_blob_name: str):
		"""Delete file"""
		try:
			blob = self.bucket.blob(destination_blob_name)
			blob.delete()
		except Exception as e:
			print(e)
	