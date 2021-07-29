import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/screens/wrapper.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/hex_color.dart';
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
        theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: HexColor('f8f8f8'),
          colorScheme: ColorScheme(
            primary: HexColor("#28c76f"),
            primaryVariant: HexColor("#1f9d57"),
            secondary: HexColor('#7367F0'),
            secondaryVariant: HexColor('#9b93f5'),
            surface: HexColor('#ffffff'),
            background: HexColor('#f8f8f8'),
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.grey.shade400,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          fontFamily: 'Kanit',
          textTheme: TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            headline2: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            headline3: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            headline4: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            headline5: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor("#101010"),
            ),
            bodyText1: TextStyle(
              fontWeight: FontWeight.normal,
              color: HexColor("#101010"),
              fontSize: 20,
            ),
            bodyText2: TextStyle(
              fontWeight: FontWeight.normal,
              color: HexColor("#101010"),
              fontSize: 18,
            ),
          ),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
