import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';

// == 전역 유저 상태 관리 == //
class UserInfo extends ChangeNotifier {
  final UserRepository _repository;
  final UserModel _user;

  UserInfo(
    this._repository,
    this._user,
  ) {
    _userName = _user.user_name;
    _userTel = _user.user_tel;
    _userHp = _user.user_hp;

    _userCash = 45000;
    _userLoginCnt = 100;

    // === Pet === //
    _mainPet = 1;
    _mainPerLv = 9;
    _mainPetExp = 180;
    _mainPetName = "왕귀여워";

    listenEvents();
  }

  // === Status === //
  // TODO: 객체로 묶을 수 있으면 묶기
  late String _userName;
  late String _userTel;
  late int _userHp;
  late int _userCash;
  late int _userLoginCnt;

  late int _mainPet;
  late int _mainPerLv;
  late int _mainPetExp;
  late String _mainPetName;

  // === Getters === //
  int get userId => _user.user_id;
  String get userName => _user.user_name;

  UserModel get user => _user;
  int get petId => _mainPet;
  int get petLv => _mainPerLv;
  int get userCash => _userCash;
  int get petExp => _mainPetExp;
  String get mainPetName => _mainPetName;

  // === Setters === //
  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  set userHp(int hp) {
    _userHp = hp;
    notifyListeners();
  }

  set petExp(int exp) {
    _mainPetExp = exp;
    notifyListeners();
  }

  set userCash(int cash) {
    _userCash = cash;
    notifyListeners();
  }

  // === Stream listener === //
  void listenEvents() {
    EventService.stream.listen((event) {
      if (event == EventType.update_status) {
        LOG.log("업데이트 유저 정보");
      }
    });
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
