import 'package:flutter/material.dart';

/// 로그인 상태 모델
class UserLoginModel extends ChangeNotifier {
  String? name;
  String? tel;
  int kakaoId;

  UserLoginModel(this.kakaoId, this.name, this.tel);
}

class UserResponse {
  final int userId;
  final String userName;
  final String userTel;
  final int userKakaoId;
  final int userHp;

  UserResponse(
      {required this.userId,
      required this.userName,
      required this.userTel,
      required this.userKakaoId,
      required this.userHp});

  // TODO: regAt, uptAt, lastLogin?

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        userId: json["userId"],
        userName: json["userName"],
        userTel: json["userTel"],
        userKakaoId: json["userKakaoId"],
        userHp: json["userHp"]);
  }
}
