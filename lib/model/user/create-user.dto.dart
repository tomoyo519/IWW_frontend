// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';

/// 로그인 상태 모델
class CreateUserDto extends ChangeNotifier {
  String? user_name;
  String? user_tel;
  String? user_kakao_id;

  CreateUserDto(this.user_name, this.user_tel, this.user_kakao_id);

  String toJson() => json.encode({
        'user_name': user_name,
        'user_tel': user_tel,
        'user_kakao_id': user_kakao_id
      });
}
