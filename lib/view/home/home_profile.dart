import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/view/_common/profile_image.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

// 홈에 표시되는 프로필 영역
class HomeProfile extends StatelessWidget {
  final UserInfo user;
  const HomeProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<TodoViewModel>(context);
    final user = Provider.of<UserInfo>(context);

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ProfileImage(
                width: 70,
                height: 70,
                userId: user.user_id,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "안녕하세요 ${user.user_name}님 👋",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "오늘의 할일은 무엇인가요?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
