import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String text,
  required Widget icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: 25, child: icon),
            Text(
              text, // 텍스트
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 2), // 스낵바 표시 시간 설정
    ),
  );
}
