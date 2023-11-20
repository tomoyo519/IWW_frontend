import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';

class SignUpViewModel extends ChangeNotifier {
  // User information
  String _name = '';
  String _tel = '';
  int _kakaoId = 0;
  String get name => _name;
  set name(String val) => _name = val;
  set tel(String val) => _tel = val;
  set kakaoId(int val) => _kakaoId = val;

  // Page index
  int _pageIdx = 0;
  int get pageIdx => _pageIdx;
  set pageIdx(int val) => _pageIdx = val;

  // Visibility
  bool _isCodeFieldVisible = false;
  bool get isCodeFieldVisible => _isCodeFieldVisible;
  set isCodeFieldVisible(bool val) {
    _isCodeFieldVisible = val;
    notifyListeners();
  }

  bool _isRegisterBtnEnabled = false;
  bool get isRegisterBtnEnabled => _isCodeFieldVisible;
  set isRegisterBtnEnabled(bool val) {
    _isRegisterBtnEnabled = val;
    notifyListeners();
  }

  void sendSms() {
    // TODO: Send sms via firebase.
    log("문자를 보냈다고 치자");
  }

  // 회원가입
  Future<bool?> signUp() async {
    return await UserRepository.createUser(_name, _tel);
  }
}
