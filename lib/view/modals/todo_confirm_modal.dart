import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

void showTodoConfirmModal(BuildContext context, String? message) {
  if (message == null) return;
  final UserInfo user = Provider.of<UserInfo>(context, listen: false);
  final TodoRepository todoRepository = Provider.of<TodoRepository>(context, listen: false);

  // message에서 필요한 데이터 파싱
  Map<String, dynamic> data = jsonDecode(message);
  String todoImg = data['todoImg'];
  int senderId = data['senderId'];
  String senderName = data['senderName'];
  int todoId = data['todoId'];
  String todoName = data['todoName'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(todoName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // 사진 전체 화면으로 확대
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FullScreenImage('${Secrets.REMOTE_SERVER_URL}' + todoImg),
                ));
              },
              child: Image.network(
                  '${Secrets.REMOTE_SERVER_URL}' + todoImg,
                  fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(todoName)),
                Text(senderName),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // TODO: todo 업데이트 로직 및 socket.emit 구현
              bool result =
                  await todoRepository.confirmGroupTodo(todoId.toString());
              if (result) {
                var data = {'userId': user.userId, 'todoId': todoId};
                EventService.sendEvent('confirmResponse', data);
              }
            },
            child: Text('인증 완료'),
          ),
        ],
      );
    },
  );
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
