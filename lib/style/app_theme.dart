// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme _inst = AppTheme._internal();
  AppTheme._internal();

  static String FONT_FAMILY = 'NanumSquareRound';

  static Color PRI_COLOR = Colors.orange;
  static Color SEC_COLOR = Colors.purple;

  static ThemeData getapptheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: FONT_FAMILY,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        titleSmall: TextStyle(fontSize: 18, color: Colors.black),
        headlineLarge: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontSize: 22, color: Colors.black),
        headlineSmall: TextStyle(fontSize: 20, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: FONT_FAMILY,
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
