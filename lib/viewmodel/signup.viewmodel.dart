import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/service/auth.service.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService authService;
  SignUpViewModel(this.authService);

  // User information
  String _name = '';
  String _tel = '';
  String get name => _name;
  set name(String val) => _name = val;
  set tel(String val) => _tel = val;

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
  Future<UserInfo?> signUp() async {
    return await authService.signup(_name, _tel);
  }
}
