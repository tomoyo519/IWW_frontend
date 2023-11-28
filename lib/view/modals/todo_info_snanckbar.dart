import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String text,
  required Widget icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon,
          Text(
            text,
            style: TextStyle(
              color: Colors.black54,
            ),
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 5), // 스낵바 표시 시간 설정
    ),
  );
}
