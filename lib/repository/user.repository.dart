import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/screens/user.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// 유저 관련 리포지토리
/// TODO: provider 패턴으로 바꾸기
class UserRepository {
  UserRepository._internal();
  static final _instance = UserRepository._internal();
  static UserRepository get instance => _instance;

  // TODO: 테스트용 유저 생성
  static Future<bool?> createTestUser(UserRequest user) async {
    return await RemoteDataSource.post("/user",
        body: jsonEncode({
          'user_name': user.user_name,
          'user_tel': user.user_tel,
          'user_kakao_id': user.user_kakao_id
        })).then((response) {
      if (response.statusCode == 200) {
        log("Create user: ${json.decode(response.body).toString()}");
        return true;
      } else {
        return false;
      }
    });
  }

  // 현재 로그인한 유저 생성
  static Future<bool?> createUser(String name, String tel) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // Local
    // kakao_id는 로그인 완료 후 저장됨
    await pref.setString("user_name", name);
    await pref.setString("user_tel", tel);
    await pref.setInt("user_hp", 0);
    log("Saved in SharedPreferences: $name");

    String? user_kakao_id = pref.getString("user_kakao_id");
    if (user_kakao_id == null || user_kakao_id.isEmpty) {
      log("No saved user kakao id in device");
      return false;
    }

    // Remote
    // 로컬 스토리지에 저장해둔 파일 불러오기
    File image = await LocalStorage.read("$user_kakao_id.jpg");

    try {
      var response = await RemoteDataSource.postFormData("user",
          body: {
            "user_name": name,
            "user_tel": tel,
            "user_kakao_id": user_kakao_id
          },
          file: image,
          filename: '$user_kakao_id.jpg');
      final responseString = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseString);

      if (response.statusCode == 200) {
        // JSON 데이터를 User 객체로 변환
        final userResponse = UserResponse.fromJson(jsonResponse);
        log("User created: ${userResponse.toString()}");

        // SharedPreference에 아이디 저장하고 결과 반환
        return pref
            .setInt("user_id", userResponse.user_id)
            .then((result) => result);
      } else {
        log("Error while creating user: ${jsonResponse.toString()}");
        return false;
      }
    } catch (error) {
      log("Server response error: $error");
      return false;
    }
  }

  static Future<String?> getUserKakaoId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user_kakao_id");
  }

  static addFriendByTel(String tel) async {
    // 네트워크 연결 검사
    // await RemoteDataSource.get("")
  }
}
