// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme _inst = AppTheme._internal();
  AppTheme._internal();

  static String font = 'NanumSquareRound';

  // * ==== Button Colors ==== * //
  static Color primary = Color.fromARGB(255, 240, 166, 54);
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
        primaryColorLight: primary,
        primaryColor: primary,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(fontSize: 18, color: Colors.black),
          headlineLarge: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(fontSize: 22, color: Colors.black),
          headlineSmall: TextStyle(fontSize: 20, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontFamily: font,
            color: Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              color: primary,
            ),
          ),
        ),
        tabBarTheme: TabBarTheme(
            labelStyle: TextStyle(
          fontFamily: font,
        )));
  }
}
