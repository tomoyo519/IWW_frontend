import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/screens/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 유저 관련 리포지토리
class UserRepository {
  // 싱글톤 객체
  UserRepository._internal();
  static final _instance = UserRepository._internal();
  static UserRepository get instance => _instance;

  static void createUser(UserLoginModel user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // Local
    // kakao_id는 로그인 완료 후 저장됨
    await pref.setString("user_name", user.name!);
    await pref.setString("user_tel", user.tel!);
    await pref.setInt("user_hp", 0);
    log("Saved in SharedPreferences: ${user.name}");

    // Remote
    await RemoteDataSource.post("/auth/signup", body: user)
        .then((response) => log(response.toString()));
  }

  static Future<int?> getUserKakaoId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("user_kakao_id");
  }

  static addFriendByTel(String tel) async {
    // 네트워크 연결 검사
    // await RemoteDataSource.get("")
  }
}
