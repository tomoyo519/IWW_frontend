import 'dart:convert';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/notification/notification.model.dart';

class NotificationRepository {
  List<Notification> dummy = [
    Notification(
        notiId: '6',
        receiverId: '1',
        receiverName: '세준',
        senderId: '2',
        senderName: '병철',
        notiType: 4,
        reqType: 0,
        subId: 0,
        todoTitle: ''),
    Notification(
        notiId: '5',
        receiverId: '1',
        receiverName: '세준',
        senderId: '3',
        senderName: '소정',
        notiType: 3,
        reqType: 0,
        subId: 0,
        todoTitle: '알림 만들기'),
    Notification(
        notiId: '4',
        receiverId: '1',
        receiverName: '세준',
        senderId: '2',
        senderName: '병철',
        notiType: 2,
        reqType: 0,
        subId: 0,
        todoTitle: '미라클 모닝하기'),
    Notification(
        notiId: '3',
        receiverId: '1',
        receiverName: '세준',
        senderId: '4',
        senderName: '다희',
        notiType: 1,
        reqType: 0,
        subId: 0,
        todoTitle: ''),
    Notification(
        notiId: '2',
        receiverId: '1',
        receiverName: '세준',
        senderId: '3',
        senderName: '소정',
        notiType: 0,
        reqType: 0,
        subId: 0,
        todoTitle: ''),
    Notification(
        notiId: '1',
        receiverId: '1',
        receiverName: '세준',
        senderId: '2',
        senderName: '병철',
        notiType: 0,
        reqType: 1,
        subId: 0,
        todoTitle: ''),
  ];

  Future<List<Notification>> getNoti(int? userId) async {
    // return await RemoteDataSource.get("/notification").then((response) {
    //   if (response.statusCode == 200) {
    //     List<dynamic> jsonData = jsonDecode(response.body);

    //     if (jsonData.isEmpty) {
    //       return [];
    //     }

    //     List<Notification>? data =
    //         jsonData.map((data) => Notification.fromJson(data)).toList();

    //     return data;
    //   }

    //   return [];
    // });
    return dummy;
  }

  Future<bool> createNoti(int? receiverId, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post(
      "/notification",
      body: json,
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  Future<bool> updateNoti(String id, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.put(
      "/notification/$id",
      body: json,
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
