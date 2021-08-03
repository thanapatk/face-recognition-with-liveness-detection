import 'package:flutter/material.dart';
import 'package:web/shared/hex_color.dart';

enum Pages { home, profile, signOut }

enum Status { onTime, late }
Text statusWidgets(Status? status, TextStyle textStyle) {
  switch (status) {
    case Status.onTime:
      return Text('เข้าเรียน', style: textStyle.copyWith(color: Colors.green));
    case Status.late:
      return Text('สาย', style: textStyle.copyWith(color: Colors.red));
    default:
      return const Text('');
  }
}

const String storageBucketName = "scan-face-49afb.appspot.com";

ThemeData psmTheme = ThemeData(
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
  hintColor: Colors.grey.shade400,
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
);

InputDecoration textInputDecoration = InputDecoration(
  fillColor: psmTheme.colorScheme.surface,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: psmTheme.hintColor, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: psmTheme.colorScheme.primary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: psmTheme.colorScheme.primary, width: 2),
  ),
  hintStyle: TextStyle(
      fontWeight: FontWeight.normal, color: psmTheme.hintColor, fontSize: 20),
);
