class UserData {
  final String uid;
  final String sid;
  final String prefix;
  final String firstname;
  final String lastname;
  final String classroom;
  String picUrl;

  UserData({
    required this.uid,
    required this.sid,
    required this.prefix,
    required this.firstname,
    required this.lastname,
    required this.classroom,
  }) : picUrl = 'https://epsm.spsm.ac.th/files/student/photo/$sid.jpg';
}
