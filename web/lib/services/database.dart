import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return UserData(
      uid: uid,
      sid: data['sid'],
      firstname: data['firstname'],
      lastname: data['lastname'],
      classroom: data['classroom'],
    );
  }

  Stream<UserData> get userData =>
      usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
}
