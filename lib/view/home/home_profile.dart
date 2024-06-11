import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

// 홈에 표시되는 프로필 영역
// 2023.12.6 현재 사용하지 않음
class HomeProfile extends StatelessWidget {
  final UserInfo user;
  const HomeProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInfo>(context);
    String today = DateFormat('M월 d일 E요일', 'ko_KO').format(DateTime.now());

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              children: [
                TextSpan(text: today),
                // TextSpan(
                //   text: user.userName,
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                TextSpan(
                  text: " 오늘의 할일은? 👋",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
