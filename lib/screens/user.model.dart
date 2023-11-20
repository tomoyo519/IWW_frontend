import 'dart:convert';

import 'package:flutter/material.dart';

/// 로그인 상태 모델
class UserRequest extends ChangeNotifier {
  String? user_name;
  String? user_tel;
  String? user_kakao_id;

  UserRequest(this.user_name, this.user_tel, this.user_kakao_id);

  String toJson() => json.encode({
        'user_name': user_name,
        'user_tel': user_tel,
        'user_kakao_id': user_kakao_id
      });
}

class UserResponse {
  final int user_id;
  final String user_name;
  final String user_tel;
  final int user_hp;

  UserResponse(
      {required this.user_id,
      required this.user_name,
      required this.user_tel,
      required this.user_hp});

  // TODO: regAt, uptAt, lastLogin?

  factory UserResponse.fromJson(String body) {
    Map<String, dynamic> data = json.decode(body);
    return UserResponse(
        user_id: data["user_id"],
        user_name: data["user_name"],
        user_tel: data["user_tel"],
        user_hp: data["user_hp"]);
  }
}
