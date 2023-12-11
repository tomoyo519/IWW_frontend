// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme _inst = AppTheme._internal();
  AppTheme._internal();

  static String font = 'NanumSquareRound';

  // * ==== Button Colors ==== * //
  static Color primary = Color(0xfff08636);
  static Color onPrimary = Colors.white;
  static Color secondary = Color.fromARGB(255, 133, 39, 176);
  static Color onSecondary = Colors.white;
  static Color tertiary = Color(0xff57c7c9);
  static Color onTertiary = Colors.white;
  static Color shaded = Colors.grey.shade300;
  static Color onShaded = Colors.black;
  static Color disabled = Colors.grey.shade200;
  static Color onDisabled = Colors.black;

  static ThemeData getapptheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: font,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: font,
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
