import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/user/attendance.model.dart';
import 'package:iww_frontend/model/user/get-user-by-contact.dto.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 로컬 캐시 및 DB에서 유저 데이터를 관리합니다.
class UserRepository {
  /// ================== ///
  ///       Create       ///
  /// ================== ///

  // 현재 로그인한 유저 생성
  Future<GetUserResult?> createUser(String userName, String userTel,
      String userKakaoId, String petName) async {
    // 서버로 유저 정보 전송
    Response response = await RemoteDataSource.post(
      "/auth/signup",
      body: {
        "user_name": userName,
        "user_tel": userTel,
        "user_kakao_id": userKakaoId,
        "user_pet_name": petName,
      },
    );

    if (response.statusCode != 201) {
      return null;
    }

    var jsonBody = jsonDecode(response.body)['result'];

    Item pet = Item.fromJson(jsonBody['user_pet']);
    String token = jsonBody['token'];
    UserModel user = UserModel.fromJson(jsonBody['user']);

    // 로그인 정보를 로컬에 저장
    await LocalStorage.saveKey('jwt', token);
    // await LocalStorage.saveKey("user_info", jsonEncode(user));

    return GetUserResult(user: user, pet: pet);
  }

  // 유저 프로필 이미지 서버로 전송
  Future<bool> createUserProfile(int userId) async {
    // 로컬 스토리지에 저장해둔 파일 불러오기
    File image = await LocalStorage.read("$userId.jpg");

    return await RemoteDataSource.postFormData(
      "/user/$userId/profile",
      'profile',
      file: image,
      filename: '$userId.jpg',
    ).then((response) => response.statusCode == 201);
  }

  // 유저 이름 유니크 테스트
  Future<bool?> isUserNameUnique(String name) async {
    Response response = await RemoteDataSource.post(
      "/auth/valid",
      body: {
        "user_name": name,
      },
    );

    LOG.log(response.body);
    if (response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      return jsonData['result'] as bool;
    }
    return null;
  }

  /// ================== ///
  ///        Read        ///
  /// ================== ///

  Future<GetUserResult?> getUser() async {
    return await RemoteDataSource.get("/user").then((response) {
      LOG.log(response.body);
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body)['result'];
        Item pet = Item.fromJson(jsonBody['user_pet']);
        UserModel user = UserModel.fromJson(jsonBody['user']);
        return GetUserResult(user: user, pet: pet);
      } else {
        // 해당 유저가 없거나 예외 반환한 경우
        return null;
      }
    });
  }

  // 연락처 기준으로 유저 정보 조회
  Future<List<UserModel>?> getUsersByContacts(
      GetUsersByContactsDto body) async {
    return await RemoteDataSource.post("/user/contacts", body: body.toJson())
        .then((response) {
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        // JSON 문자열을 Dart 객체로 변환
        var jsonData = json.decode(response.body);
        var listData = jsonData as List;
        if (listData.isNotEmpty) {
          return listData
              .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return null;
        }
      } else {
        LOG.log("Fail to fetch user infos");
        return null;
      }
    });
  }

  Future<int> getUserHealth(int roomOwner) async {
    return RemoteDataSource.get('/user/status/$roomOwner').then((response) {
      var json = jsonDecode(response.body);
      if (json['result'] != null) {
        return json['result']['user_hp'];
      }
      // return json['result']['user_hp'];
      else {
        return 0;
      }
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  Future<bool> updateUserPet(int userId, int petId) {
    return RemoteDataSource.put("/user/$userId/pet/$petId")
        .then((response) => response.statusCode == 200);
  }

  /// ================== ///
  ///       Delete       ///
  /// ================== ///

  // 유저 아이디를 기준으로 DB에서 삭제 처리
  Future<bool> deleteUserById(int userId) async {
    return RemoteDataSource.delete("/user/$userId")
        .then((response) => response.statusCode == 200);
  }

  // 유저 카카오 아이디를 기준으로 DB에서 삭제 처리
  Future<bool> deleteUserByKakaoId(String kakaoId) async {
    return RemoteDataSource.delete("/user?user_kakao_id=$kakaoId")
        .then((response) => response.statusCode == 200);
  }

  // 로컬 캐시에서 유저 정보 클리어
  Future<bool> deleteUserInLocal() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await pref.remove("user_id");
      await pref.remove("user_name");
      await pref.remove("user_tel");
      await pref.remove("user_kakao_id");
      await pref.remove("user_hp");
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<UserAttandance>?> fetUserAtt(userId) async {
    try {
      return RemoteDataSource.get("/attendance/${userId}").then((res) {
        if (res.statusCode == 200) {
          var jsonData = json.decode(res.body);

          LOG.log('${jsonData["result"]}');
          return List<UserAttandance>.from(
              jsonData["result"].map((item) => UserAttandance.fromJson(item)));
        }
      });
    } catch (err) {
      return null;
    }
  }
}
