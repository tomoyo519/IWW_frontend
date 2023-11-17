import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/screens/landing.model.dart';
import 'package:iww_frontend/screens/user.repository.dart';

class SignUpViewModel extends ChangeNotifier {
  final UserRemoteRepository userRemoteRepository = UserRemoteRepository();

  // 회원가입 화면 상태
  // TODO: encapsulate?
  String name = '';
  String tel = '';
  int kakaoId = 0;

  bool _isCodeFieldVisible = false;
  bool get isCodeFieldVisible => _isCodeFieldVisible;

  int pageIdx = 0;

  void showCodeField() {
    _isCodeFieldVisible = true;
  }

  void setPage(int idx) {
    pageIdx = idx;
    notifyListeners();
  }

  void sendSms() {
    // TODO: Send sms via firebase.
    log("문자를 보냈다고 치자");
  }

  void signIn() {
    userRemoteRepository.createUser(UserLoginModel(kakaoId, name, tel));
  }
}
