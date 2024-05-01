import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';

class MyInfoEdit extends StatefulWidget {
  final String userName; // userName을 받아올 변수를 선언합니다.
  final TextEditingController myController; // 컨트롤러를 선언합니다.

  MyInfoEdit({Key? key, required this.userName}) // 생성자에서 userName을 필수 인자로 받습니다.
      : myController = TextEditingController(
            text: userName), // 컨트롤러의 초기값을 userName으로 설정합니다.
        super(key: key);

  @override
  State<MyInfoEdit> createState() => _MyInfoEditState();
}

class _MyInfoEditState extends State<MyInfoEdit> {
  String myname = "";

  setMyname(String value) {
    setState(() {
      myname = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      myname = widget.userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserInfo>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            child: Text(
              "편집 완료",
              style: TextStyle(color: Colors.black), // 여기서 색상을 직접 지정
            ),
            onPressed: () async {
              final userInfo = context.read<UserInfo>();
              var result = await userInfo.reNameUser(myname, userInfo);
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text("이름 변경이 완료 되었어요!")));
                Navigator.pop(context, true); // true 이름이 변경됨
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/profile.png',
              width: 80,
              height: 80,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "닉네임",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16, // 글자 크기를 20으로 설정합니다.
                    fontWeight: FontWeight.bold, // 글자 두께를 bold로 설정합니다.
                  ),
                ),
              ),
              // Text(
              //   myInfo.userName,
              //   textAlign: TextAlign.left,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Material(
                  color: Colors.white,
                  child: TextField(
                    onChanged: (value) {
                      setMyname(value);
                    },
                    controller: widget.myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[200] ?? Colors.grey)),
                      filled: true, // 배경색을 채우도록 설정합니다.
                      fillColor: Colors.grey[200], // 배경색을 회색으로 설정합니다.
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
