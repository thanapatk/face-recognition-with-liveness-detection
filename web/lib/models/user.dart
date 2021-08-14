class UserData {
  final String uid;
  final String? sid;
  final String prefix;
  final String firstname;
  final String lastname;
  final String? classroom;
  final String role;
  late String picUrl;

  UserData({
    required this.uid,
    this.sid,
    required this.prefix,
    required this.firstname,
    required this.lastname,
    this.classroom,
    required this.role,
  }) : picUrl = 'https://epsm.spsm.ac.th/files/student/photo/$sid.jpg';
}
