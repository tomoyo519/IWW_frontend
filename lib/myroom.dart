// myroom.dart
import 'package:flutter/material.dart';
import 'guestbook.dart'; // guestbook.dart 임포트

class MyRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommentsProvider commentsProvider = CommentsProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Room'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showCommentsBottomSheet(context, commentsProvider),
          child: Text('방명록 보기'),
        ),
      ),
    );
  }
}