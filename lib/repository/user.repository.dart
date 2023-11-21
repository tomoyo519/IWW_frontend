import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/get-user-by-contact.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 유저 관련 리포지토리
class UserRepository {
  // 현재 로그인한 유저 생성
  Future<bool?> createUser(String name, String tel) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // Local
    // user_kakao_id는 로그인 완료 후 저장됨
    await pref.setString("user_name", name);
    await pref.setString("user_tel", tel);
    await pref.setInt("user_hp", 0);
    log("Saved in SharedPreferences: $name");

    String? kakaoId = pref.getString("user_kakao_id");
    if (kakaoId == null || kakaoId.isEmpty) {
      log("No saved user kakao id in device");
      return false;
    }

    // Remote
    Response response = await RemoteDataSource.post("/user",
        body: {"user_name": name, "user_tel": tel, "user_kakao_id": kakaoId});

    final jsonData = json.decode(response.body);

    if (response.statusCode == 201) {
      // JSON 데이터를 User 객체로 변환
      final userResponse = UserInfo.fromJson(jsonData);
      log("User created: ${userResponse.user_id}");

      // SharedPreference에 아이디 저장하고 결과 반환
      if (await pref.setInt("user_id", userResponse.user_id)) {
        // 로컬에 아이디 저장 완료후 이미지 서버로 전송
        // 로컬 저장 경로는 카카오 아이디, 서버 저장 경로는 유저 아이디 참고
        return await _createUserProfile(kakaoId, userResponse.user_id);
      }
      return false;
    } else {
      log("Error while creating user: ${jsonData.toString()}");
      return false;
    }
  }

  // 카카오 아이디 기준으로 유저 정보 조회
  Future<UserInfo?> getUserByKakaoId(String kakaoId) async {
    return await RemoteDataSource.get("/user?user_kakao_id=$kakaoId")
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return UserInfo.fromJson(jsonData);
      } else {
        return null;
      }
    });
  }

  // 이름을 기준으로 유저 정보 조회
  Future<UserInfo?> getUserByName(String name) async {
    return await RemoteDataSource.get("/user?user_name=$name").then((response) {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return UserInfo.fromJson(jsonData);
      } else {
        return null;
      }
    });
  }

  // 연락처 기준으로 유저 정보 조회
  Future<List<UserInfo>?> getUsersByContacts(GetUsersByContactsDto body) async {
    return await RemoteDataSource.post("/user/contacts", body: body.toJson())
        .then((response) {
      if (response.statusCode == 201) {
        var jsonData = json.decode(response.body); // JSON 문자열을 Dart 객체로 변환
        return (jsonData as List)
            .map((item) => UserInfo.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        log("Fail to fetch user infos");
        return null;
      }
    });
  }

  // 유저 프로필 이미지 서버로 전송
  Future<bool?> _createUserProfile(kakaoId, userId) async {
    // 로컬 스토리지에 저장해둔 파일 불러오기
    File image = await LocalStorage.read("$kakaoId.jpg");

    return await RemoteDataSource.postFormData(
            "/user/$userId/profile", 'profile',
            file: image, filename: '$userId.jpg')
        .then((response) => response.statusCode == 201);
  }

  // 로컬 SharedPreference에서 유저 아이디 가져오기
  Future<int?> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("user_id");
  }
}
