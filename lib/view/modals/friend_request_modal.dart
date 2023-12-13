import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/notification.repository.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

void showFriendRequestModal(BuildContext context, String? message) {
  if (message == null) return;
  final UserInfo user = Provider.of<UserInfo>(context, listen: false);
  final NotificationRepository notificationRepository =
      NotificationRepository();
  final FriendRepository friendRepository = FriendRepository();

  // message에서 필요한 데이터 파싱
  Map<String, dynamic> data = jsonDecode(message);
  String msg = data['message'];
  int senderId = data['senderId'];
  String senderName = data['senderName'];
  int notiId = data['notiId'];

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('친구 요청'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey[300]!),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              onPressed: () async {
                // 거절 버튼 로직
                Map<String, dynamic> data = {
                  "noti_id": notiId.toString(),
                  "req_type": '2',
                };
                await friendRepository.createFriend(user.userId, senderId);
                await notificationRepository.updateNoti(
                    notiId.toString(), data);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                '거절',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                // 수락 버튼 로직
                Map<String, dynamic> data = {
                  "noti_id": notiId.toString(),
                  "req_type": '1',
                };
                await friendRepository.createFriend(user.userId, senderId);
                await notificationRepository.updateNoti(
                    notiId.toString(), data);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                '수락',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ],
        );
      });
}
