// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserInfo {
  final int user_id;
  final String user_name;
  final String user_tel;
  final String user_kakao_id;
  final int user_hp;

  UserInfo(
      {required this.user_id,
      required this.user_name,
      required this.user_tel,
      required this.user_kakao_id,
      required this.user_hp});

  // TODO: regAt, uptAt, lastLogin?

  factory UserInfo.fromJson(Map<String, dynamic> data) {
    return UserInfo(
        user_id: data["user_id"],
        user_name: data["user_name"],
        user_tel: data["user_tel"],
        user_kakao_id: data["user_kakao_id"],
        user_hp: data["user_hp"]);
  }
}
