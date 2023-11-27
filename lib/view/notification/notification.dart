import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/notification.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/appbar.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  List<Notification> notifications = [];
  final NotificationRepository notificationRepository =
      NotificationRepository();

  @override
  void initState() {
    super.initState();
    fetchNoti();
  }

  Future<void> fetchNoti() async {
    List<Notification> fectedNoti = await notificationRepository.getNoti(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder:(context, index) {
          var noti = notifications[index];
          return ListTile (
            title: Text(buildNotiMessage(noti)),
            trailing: buildTrailWidget(noti),
            onTap: () => navigateToSender(noti),
          );
        },
      )
    );

  String 
}
