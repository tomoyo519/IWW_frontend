import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepository {
  // 친구 조회
  Future<List<UserInfo>?> getFriends() async {
    int? userId = await _getUser();

    if (userId == null) {
      // TODO: 예외처리 (백그라운드 로그인)
      return null;
    }
    return await RemoteDataSource.get("/friend/$userId").then((response) {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return (jsonData as List)
            .map((item) => UserInfo.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        log("Fail to fetch friend data.");
        return null;
      }
    });
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
