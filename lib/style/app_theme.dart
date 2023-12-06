import 'package:flutter/material.dart';

ThemeData getapptheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );
}
