import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/notification.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/notification/notification.model.dart'
    as model;

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
    fetchNoti();
  }

  Future<void> fetchNoti() async {
    try {
      List<model.Notification>? fetchedNoti =
          await notificationRepository.getNoti(1);
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
        appBar: MyAppBar(),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var noti = notifications[index];
            return ListTile(
              leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          '${Secrets.REMOTE_SERVER_URL}/image/${noti.senderId}.jpg'),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: Image.network(
                        '${Secrets.REMOTE_SERVER_URL}/image/${noti.senderId}.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          );
                        },
                      ))),
              title: Text(buildNotiMessage(noti)),
              trailing: buildTrailWidget(noti),
              onTap: () => navigateToSender(noti),
            );
          },
        ));
  }

  String buildNotiMessage(model.Notification noti) {
    var sender = noti.senderName;
    String message;
    switch (noti.notiType) {
      case 0:
        message = '$sender님이 친구 추가 요청을 보냈습니다.';
        break;
      case 1:
        message = '$sender님이 친구 추가 요청을 수락하였습니다.';
        break;
      case 2:
        message = '$sender님이 "${noti.todoTitle}"에 대한 인증을 요청하였습니다.';
        break;
      case 3:
        message = '$sender님이 "${noti.todoTitle}"에 대한 인증을 완료하였습니다.';
        break;
      case 4:
        message = '$sender님이 방명록에 댓글을 남겼습니다.';
        break;
      default:
        message = '';
    }
    LOG.log(message);
    return message;
  }

  Widget? buildTrailWidget(model.Notification noti) {
    if (noti.notiType == 0 && noti.reqType == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () async {
                noti.reqType = 1;
                await notificationRepository.updateNoti(
                    noti.notiId, noti.toJson());
                fetchNoti();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('수락')),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              noti.reqType = 2;
              await notificationRepository.updateNoti(
                  noti.notiId, noti.toJson());
              fetchNoti();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('거절'),
          ),
        ],
      );
    } else if (noti.notiType == 2) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Text('확인하기'),
      );
    }
    return null;
  }

  void navigateToSender(model.Notification noti) {
    switch (noti.notiType) {
      case 0:
        Navigator.pushNamed(context, "/myroom", arguments: 1);
        break;
      case 1:
        Navigator.pushNamed(context, "/myroom", arguments: 1);
        break;
      case 2:
        break;
      case 3:
        // TODO - 해당 todo의 인증샷에 대한 modal 창으로 redirect
        break;
      case 4:
        // TODO - 내 방명록의 해당 댓글 위치로 redirect
        break;
    }
  }
}
