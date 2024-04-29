import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/friend/friend.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/utils/logger.dart';

class FriendRepository {
  List<UserModel> dummy = [
    UserModel(
      user_id: 1,
      user_name: '신병철',
      user_tel: '010-1111-1111',
      user_kakao_id: '1',
      user_hp: 70,
      user_cash: 0,
      last_login: "",
      login_cnt: 0,
      login_seq: 0,
    ),
    UserModel(
      user_id: 2,
      user_name: '정다희',
      user_tel: '010-2222-2222',
      user_kakao_id: '2',
      user_hp: 80,
      user_cash: 0,
      last_login: "",
      login_cnt: 0,
      login_seq: 0,
    ),
    UserModel(
      user_id: 13,
      user_name: '이인복',
      user_tel: '010-3333-3333',
      user_kakao_id: '3',
      user_hp: 60,
      user_cash: 0,
      last_login: "",
      login_cnt: 0,
      login_seq: 0,
    ),
    UserModel(
      user_id: 5,
      user_name: '이소정',
      user_tel: '010-5555-5555',
      user_kakao_id: '5',
      user_hp: 90,
      user_cash: 0,
      last_login: "",
      login_cnt: 0,
      login_seq: 0,
    ),
  ];

  Future<List<FriendInfo>> getFriends(int userId) async {
    List<FriendInfo> friends = [];

    await RemoteDataSource.get("/friend/$userId").then((response) {
      LOG.log("Get friends: ${response.statusCode}");
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        LOG.log(response.body);
        List<dynamic> resultList = data["result"];

        // user_id, user_name, total_exp, pet_name 네 개의 필드 수신
        friends = resultList
            .map((dynamic item) => FriendInfo.fromJson(item))
            .toList();

        LOG.log('친구 숫자!: ${friends.length}, total: ${data['total']}');
      }
    }).catchError((onError) {
      LOG.log("getFriends 에러발생!! $onError");
    });

    return friends;
  }

  // 친구 생성
  Future<bool> createFriend(int userId, int friendId) async {
    return await RemoteDataSource.post(
      "/friend",
      body: {
        "user_id": userId,
        "friend_id": friendId,
      },
    ).then((response) {
      LOG.log("Create friend: ${response.statusCode}");
      return response.statusCode == 201;
    });
  }

  // 친구 삭제
  Future<bool> deleteFriend(int userId, int friendId) async {
    return await RemoteDataSource.delete(
      "/friend",
      body: {
        "user_id": userId,
        "friend_id": friendId,
      },
    ).then((response) => (response.statusCode == 200));
  }

  // Future<int?> _getUser() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   return pref.getInt("user_id");
  // }

  Future<int> getFriendStatus(int userId, int friendId) async {
    int status = 4;

    await RemoteDataSource.get("/friend/$userId/$friendId").then((response) {
      LOG.log("Get friend status : ${response.statusCode}");
      if (response.statusCode == 200) {
        LOG.log("Is $friendId my friend? : ${response.body}");
        Map<String, dynamic> data = jsonDecode(response.body);
        String result = data['msg'];
        if (result != 'nothing') {
          if (result == 'friend') status = 1;
          if (result == 'request') status = 2;
          if (result == 'requested') status = 3;
        }
      }
    }).catchError((onError) {
      LOG.log("getFriendStatus 에러발생!! $onError");
    });

    return status;
  }
}
