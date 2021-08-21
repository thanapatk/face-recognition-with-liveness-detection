import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return data['role'] == 'teacher'
        ? UserData(
            uid: uid,
            prefix: data['prefix'],
            firstname: data['firstname'],
            lastname: data['lastname'],
            role: data['role'],
          )
        : UserData(
            uid: uid,
            sid: data['sid'],
            prefix: data['prefix'],
            firstname: data['firstname'],
            lastname: data['lastname'],
            classroom: data['classroom'],
            role: data['role'],
          );
  }

  List<UserLog> _userLogFromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((dynamic snapshot) => UserLog(
            sid: snapshot.data()['sid'],
            timestamp: snapshot.data()['timestamp']))
        .toList();
  }

  Future<List<UserLog>> getUserLogs({
    required UserData userData,
    required int timestamp,
  }) async {
    int currentDay = getDateTimestamp(timestamp);
    int nextDay = getDateTimestamp(timestamp + 86400000);
    return logsCollection
        .where('timestamp', isGreaterThan: currentDay)
        .where('timestamp', isLessThan: nextDay)
        .where('sid', isEqualTo: userData.sid)
        .get()
        .then(_userLogFromQuerySnapshot);
  }

  Future<List<UserLog>> getUserLogsFromPeriod({
    required int timestamp,
    required int period,
  }) async {
    List<int>? time = periodRef[period.toString()];
    if (time != null) {
      return logsCollection
          .where('timestamp', isGreaterThan: timestamp + time.first)
          .where('timestamp', isLessThan: timestamp + time.last)
          .get()
          .then(_userLogFromQuerySnapshot);
    } else {
      return List.empty();
    }
  }

  Stream<UserData> get userData =>
      usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
}
