import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String text,
  required Widget icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 30, child: icon),
            SizedBox(
              width: 5,
            ),
            Text(
              text, // 텍스트
              style: TextStyle(color: Colors.black87),
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
