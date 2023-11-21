// myroom.dart
import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'guestbook.dart'; // guestbook.dart 임포트

class MyRoom extends StatefulWidget {
  MyRoom({Key? key}) : super(key: key);

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  @override
  Widget build(BuildContext context) {
    CommentsProvider commentsProvider = CommentsProvider();

    final userId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Room'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            int? currentUserId = await UserRepository.getUserId();
            if (mounted) {
              showCommentsBottomSheet(
                  context, commentsProvider, currentUserId.toString(), userId);
            }
          },
          child: Text('방명록 보기'),
        ),
      ),
    );
  }
}
