import 'package:flutter/material.dart';

final Map<String, ThemeData> themes = {
  'Default': ThemeData(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff111740),
    scaffoldBackgroundColor: const Color(0xff111740),
    primaryColor: const Color(0xff283593),
    primaryColorBrightness: Brightness.dark,
    accentColor: Colors.blue[300],
  ),
  'Dark': ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.blueGrey[900],
    primaryColorBrightness: Brightness.dark,
    accentColor: Colors.blue[900],
  )
};
