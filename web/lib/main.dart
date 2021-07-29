import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/screens/wrapper.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authService = AuthService();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
            initialData: null, create: (context) => _authService.user),
        StreamProvider<bool?>(
            create: (context) => _authService.isSignIn, initialData: null)
      ],
      child: MaterialApp(
        theme: psmTheme,
        home: const Wrapper(),
      ),
    );
  }
}
