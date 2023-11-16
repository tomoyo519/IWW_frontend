// msg: 가능하면 건드리지 말자 by 다희 소정
import 'package:flutter/material.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home.dart';

void main() async {
  runApp(MaterialApp(
    home: const MyApp(),
    // key: TwService.appKey,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: MyHome(),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
