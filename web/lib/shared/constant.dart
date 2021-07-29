import 'package:flutter/material.dart';
import 'hex_color.dart';

InputDecoration textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: HexColor('#28c76f'), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: HexColor('#28c76f'), width: 2),
  ),
  hintStyle: TextStyle(
      fontWeight: FontWeight.normal, color: Colors.grey.shade400, fontSize: 20),
);
