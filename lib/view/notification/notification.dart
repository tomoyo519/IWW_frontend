import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/notification.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/notification/notification.model.dart'
    as model;
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/todo_confirm_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  List<model.Notification> notifications = [];
  final NotificationRepository notificationRepository =
      NotificationRepository();

  @override
  void initState() {
    super.initState();
    fetchNoti(context);
  }

  Future<void> fetchNoti(BuildContext context) async {
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);
    try {
      List<model.Notification>? fetchedNoti =
          await notificationRepository.getNoti(user.userId);
      setState(() {
        notifications = fetchedNoti;
      });
    } catch (e) {
      // 에러 처리
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifications.isNotEmpty
          ? ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var noti = notifications[index];
                return ListTile(
                  leading: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile.png'),
                      // backgroundImage: NetworkImage(
                      //     '${Secrets.REMOTE_SERVER_URL}/image/${noti.senderId}.jpg'),
                      // onBackgroundImageError: (exception, stackTrace) {},
                      // child: Image.network(
                      //   '${Secrets.REMOTE_SERVER_URL}/image/${noti.senderId}.jpg',
                      //   fit: BoxFit.cover,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return CircleAvatar(
                      //       radius: 20,
                      //       backgroundImage: AssetImage('assets/profile.jpg'),
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                  title: Text(buildNotiMessage(noti)),
                  trailing: buildTrailWidget(noti),
                  onTap: () => navigateToSender(noti),
                );
              },
            )
          : Center(
              child: Lottie.asset('assets/empty.json',
                  repeat: true,
                  animate: true,
                  height: MediaQuery.of(context).size.height * 0.3),
            ),
    );
  }

  String buildNotiMessage(model.Notification noti) {
    var sender = noti.senderName;
    String message;
    switch (noti.notiType) {
      case '0':
        message = '$sender님이 친구 추가 요청을 보냈습니다.';
        break;
      case '1':
        message = '$sender님이 친구 추가 요청을 수락하였습니다.';
        break;
      case '2':
        message = '$sender님이 "${noti.todoTitle}"에 대한 인증을 요청하였습니다.';
        break;
      case '3':
        message = '$sender님이 "${noti.todoTitle}"에 대한 인증을 완료하였습니다.';
        break;
      case '4':
        message = '$sender님이 방명록에 댓글을 남겼습니다.';
        break;
      default:
        message = '';
    }
    LOG.log(message);
    return message;
  }

  Widget? buildTrailWidget(model.Notification noti) {
    if (noti.notiType == '0' && noti.reqType == '0') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> data = {
                  "noti_id": noti.notiId,
                  "req_type": '1',
                };
                await notificationRepository.updateNoti(noti.notiId, data);
                if (mounted) {
                  fetchNoti(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('수락')),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> data = {
                "noti_id": noti.notiId,
                "req_type": '2',
              };
              await notificationRepository.updateNoti(noti.notiId, data);
              if (mounted) {
                fetchNoti(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('거절'),
          ),
        ],
      );
    } else if (noti.notiType == '2') {
      return ElevatedButton(
        onPressed: () {
          String message = jsonEncode({
            "senderId": int.parse(noti.senderId),
            "senderName": noti.senderName,
            "todoId": noti.subId,
            "todoName": noti.todoTitle,
            "photoUrl": noti.reqType
          });
          showTodoConfirmModal(context, message);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Text('확인하기'),
      );
    }
    return null;
  }

  void navigateToSender(model.Notification noti) {
    AppNavigator nav = Provider.of<AppNavigator>(context, listen: false);
    switch (noti.notiType) {
      case '0':
      case '1':
      case '2':
      case '3':
        nav.push(AppRoute.room, argument: noti.senderId);
        break;
      case '4':
        // TODO - 내 방명록의 해당 댓글 위치로 redirect
        nav.push(AppRoute.room);
        break;
    }
  }
}
