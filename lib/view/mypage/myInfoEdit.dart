import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyInfoEdit extends StatelessWidget {
  const MyInfoEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Center(
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/profile.png',
              width: 50,
              height: 50,
            ),
          ),
          Text("닉네임"),
          Material(
            color: Colors.white,
            child: TextField(),
          ),
        ]),
      ),
    );
  }
}
