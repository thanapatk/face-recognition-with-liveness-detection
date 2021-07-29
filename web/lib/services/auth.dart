// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = _userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<User?> get user => _auth.authStateChanges();
  Stream<bool> get isSignIn =>
      (_auth.authStateChanges().map((user) => user != null));
}
