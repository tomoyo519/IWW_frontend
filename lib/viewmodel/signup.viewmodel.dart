import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService authService;
  SignUpViewModel(this.authService);

  // * ==== State ==== * //

  String _userName = '';

  String get name => _userName;
  set name(String val) {
    _userName = val;
    notifyListeners();
  }

  String _userTel = '';
  String get tel => _userTel;
  set tel(String val) {
    _userTel = val;
    notifyListeners();
  }

  String _petName = '';
  String get petName => _petName;
  set petName(String val) {
    _petName = val;
    notifyListeners();
  }

  int _pageIdx = 0;
  int get pageIdx => _pageIdx;
  set pageIdx(int val) {
    _pageIdx = val;
    notifyListeners();
  }

  // * ==== Validation ==== * //

  String? _telCode;
  String get telCode => _telCode ?? "";
  set telCode(String val) {
    _telCode = val;
    notifyListeners();
  }

  String? _userNameError;
  String get userNameError => _userNameError ?? "";
  set userNameError(String val) {
    _userNameError = val;
    notifyListeners();
  }

  String? _userTelError;
  String get userTelError => _userTelError ?? "";
  set userTelError(String val) {
    _userTelError = val;
    notifyListeners();
  }

  String? _telAuthError;
  String get telAuthError => _telAuthError ?? "";
  set telAuthError(String val) {
    _telAuthError = val;
    notifyListeners();
  }

  String? _petNameError;
  String get petNameError => _petNameError ?? "";
  set petNameError(String val) {
    _petNameError = val;
    notifyListeners();
  }

  bool _isCodeFieldVisible = false;
  bool get isCodeFieldVisible => _isCodeFieldVisible;
  set isCodeFieldVisible(bool val) {
    _isCodeFieldVisible = val;
    notifyListeners();
  }

  bool _waiting = false;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  Future<void> validateName() async {
    if (_userName.isEmpty) {
      userNameError = "닉네임을 입력해주세요";
      return;
    }

    bool? isUnique = await authService.isNameUnique(_userName);

    if (isUnique != null && isUnique == true) {
      pageIdx++;
    } else {
      userNameError = "중복된 닉네임입니다.";
    }
  }

  Future<void> validateTel() async {
    if (_userTel.isEmpty) {
      userTelError = "연락처를 입력해주세요";
      return;
    }

    EventService.publish(
      Event(
        type: EventType.onSnsAuth,
        message: "인증번호는 0000 입니다.",
      ),
    );

    isCodeFieldVisible = true;
  }

  Future<void> validateTelCode() async {
    if (_telCode == null || _telCode!.isEmpty) {
      userTelError = "인증 번호를 입력해주세요";
      return;
    }

    if (_telCode != '0000') {
      userTelError = "인증번호가 다릅니다.";
      return;
    }
    pageIdx++;
  }

  // 회원가입
  Future<void> signUp() async {
    await authService.signup(_userName, _userTel, _petName);
  }
}
