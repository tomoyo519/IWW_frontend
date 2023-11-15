import 'package:flutter/material.dart';
import 'package:tailwind/tailwind.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Text('안녕'),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "샵")
        ],
      ),
    );
  }
}
