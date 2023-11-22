import 'dart:convert';
import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepository {
  List<UserInfo> dummy = [
    UserInfo(
        user_id: 1,
        user_name: '신병철',
        user_tel: '010-1111-1111',
        user_kakao_id: '1',
        user_hp: 70),
    UserInfo(
        user_id: 2,
        user_name: '정다희',
        user_tel: '010-2222-2222',
        user_kakao_id: '2',
        user_hp: 80),
    UserInfo(
        user_id: 13,
        user_name: '이인복',
        user_tel: '010-3333-3333',
        user_kakao_id: '3',
        user_hp: 60),
    UserInfo(
        user_id: 5,
        user_name: '이소정',
        user_tel: '010-5555-5555',
        user_kakao_id: '5',
        user_hp: 90),
  ];

  // 친구 조회
  // Future<List<UserInfo>?> getFriends() async {
  //   int? userId = await _getUser();

  //   if (userId == null) {
  //     // TODO: 예외처리 (백그라운드 로그인)
  //     return null;
  //   }
  //   return await RemoteDataSource.get("/friend/$userId").then((response) {
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);
  //       return (jsonData as List)
  //           .map((item) => UserInfo.fromJson(item as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       log("Fail to fetch friend data.");
  //       return null;
  //     }
  //   });
  // }
  Future<List<UserInfo>> getFriends() async {
    return dummy;
  }

  // 친구 생성
  Future<bool> createFriend(int friendId) async {
    int? userId = await _getUser();
    if (userId == null) {
      // TODO: 예외처리 (백그라운드 로그인)
      return false;
    }

    return await RemoteDataSource.post("/friend",
        body: {"user_id": userId, "friend_id": friendId}).then((response) {
      log("Create friend: ${response.statusCode}");
      return response.statusCode == 201;
    });
  }

  // 친구 삭제
  Future<bool> deleteFriend(num friendId) async {
    int? userId = await _getUser();
    if (userId == null) {
      // TODO: 예외처리 (백그라운드 로그인)
      return false;
    }

    return await RemoteDataSource.delete("/friend",
            body: {"user_id": userId, "friend_id": friendId})
        .then((response) => (response.statusCode == 200));
  }

  Future<int?> _getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("user_id");
  }
}
