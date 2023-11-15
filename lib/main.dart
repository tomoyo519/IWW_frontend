// msg: 가능하면 건드리지 말자 by 다희 소정
import 'package:flutter/material.dart';
import 'package:tailwind/tailwind.dart';
import 'appbar.dart';
import 'bottombar.dart';

void main() async {
  await TwService.init();
  runApp(MaterialApp(
    home: const MyApp(),
    key: TwService.appKey,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Text('안녕 클레오파트라, main 함수의 body입니다.'),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
