import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';

// == 전역 유저 상태 관리 == //
class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;
  final UserInfo userInfo;

  UserProvider(
    this.userRepository,
    this.userInfo,
  ) {
    _userName = userInfo.user_name;
    _userTel = userInfo.user_tel;
    _userHp = userInfo.user_hp;
    _userCash = 45000;
    _mainPet = userInfo.pet_id ?? 1;
    _mainPetExp = 0;
    _mainPetName = "최고의파이리";
  }

  // === Status === //
  // TODO: 객체로 묶을 수 있으면 묶기
  late String _userName;
  late String _userTel;
  late int _userHp;
  late int _userCash;
  late int _mainPet;
  late int _mainPetExp;
  late String _mainPetName;

  // === Getters === //
  int get userCash => _userCash;
  int get mainPetExp => _mainPetExp;
  String get mainPetName => _mainPetName;

  UserInfo get user {
    return UserInfo(
      user_id: userInfo.user_id,
      user_name: _userName,
      user_tel: _userTel,
      user_kakao_id: user.user_kakao_id,
      user_hp: _userHp,
    );
  }

  // === Setters === //
  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  // === CRUD === //
  Future<void> updateUserHp(int hp) async {
    _userHp = hp;
    waiting = false;
  }

  Future<void> updatePetExp(int exp) async {
    _mainPetExp = exp;
    waiting = false;
  }

  Future<void> updateUserCash(int cash) async {
    _userCash = cash;
    waiting = false;
  }
}
