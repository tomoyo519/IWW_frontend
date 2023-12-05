import 'dart:convert';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/notification/notification.model.dart';

class NotificationRepository {
  Future<List<Notification>> getNoti(int? userId) async {
    return await RemoteDataSource.get("/notification/$userId").then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        if (jsonData.isEmpty) {
          return [];
        }

        List<Notification>? data =
            jsonData.map((data) => Notification.fromJson(data)).toList();

        return data;
      }

      return [];
    });
    // return dummy;
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
