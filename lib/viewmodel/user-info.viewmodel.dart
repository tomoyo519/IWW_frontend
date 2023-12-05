import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/todo/todo_today_count.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/service/reward.service.dart';

class UserInfo extends ChangeNotifier {
  final UserModel _user;
  final Item _mainPet;
  final UserRepository _repository;

  UserInfo(
    this._user,
    this._mainPet,
    this._repository,
  ) {
    _setStateFromModels(_user, _mainPet);

    // 초기 로그인 카운트 알림
    if (_user.login_cnt >= 30) {
      EventService.publish(
        Event(
          type: EventType.show_login_achieve,
          message: jsonEncode({
            "title": "로그인 카운트 30회 달성!",
          }),
        ),
      );
    }
  }

  // === Status === //
  late String _userName;
  late String _userTel;
  late int _userHp;
  late int _userCash;

  late int _itemId;
  late int _petExp;
  late String _petName;

  // === Getters === //
  UserModel get userModel => _user;
  int get userId => _user.user_id;
  String get userName => _userName;
  String get userTel => _userTel;

  int get userCash => _userCash;
  int get userHp => _userHp;
  int get itemId => _itemId;
  int get petExp => _petExp;
  String get mainPetName => _petName;

  // === Setters === //
  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  set userName(String name) {
    _userName = name;
    notifyListeners();
  }

  set userHp(int hp) {
    _userHp = hp;
    notifyListeners();
  }

  set itemId(int val) {
    _itemId = val;
    notifyListeners();
  }

  set petExp(int exp) {
    _petExp = exp;
    notifyListeners();
  }

  set userCash(int cash) {
    _userCash = cash;
    notifyListeners();
  }

  // ==== CRUD ==== //
  Future<void> fetchUser() async {
    UserModel prevUserState = _user;
    Item prevPetState = _mainPet;

    GetUserResult? fetched = await _repository.getUser();
    if (fetched == null) {
      // _authService.user = null; // 인가 정보를 삭제
      return;
    }

    LOG.log('User cash: ${fetched.user.user_cash}');
    _setStateFromModels(fetched.user, fetched.pet);
    if (prevPetState.id != fetched.pet.id) {
      // 진화함!
      EventService.publish(
        Event(
          type: EventType.show_pet_evolve,
        ),
      );
    }
  }

  // TODO type 달기
  Future<bool> reNameUser(myname, userInfo) async {
    var userInfo;

    try {
      var json = {
        "user_name": myname,
        "user_tel": userInfo._userTel,
        "user_kakao_id": userInfo.userModel.user_kakao_id
      };
      LOG.log('$json');
      var result = RemoteDataSource.put('/user/${userInfo.userId}',
              body: jsonEncode(json))
          .then((res) {
        LOG.log('${res.statusCode}');
        if (res.statusCode == 200) {
          userName = myname;
          return true;
        }
      });
    } catch (e) {
      return false;
    }
    return false;
  }

  void setStateFromTodo(bool isDone, bool isGroup, int todayDone) {
    // 리워드 계산
    int cash = RewardService.calculateNormalCash(isDone, todayDone);
    int petExp = RewardService.calculatePetExp(isDone);

    // 상태 변경
    _userCash += cash;
    _petExp += petExp;
    notifyListeners();

    //상태 변경에 따른 이벤트 트리거 ==== //
    if (cash == RewardService.FIRST_TODO_REWARD) {
      EventService.publish(Event(
        type: EventType.show_first_todo_modal,
      ));
    }
  }

  void _setStateFromModels(
    UserModel user,
    Item pet,
  ) {
    // 사용자가 변경 가능한 필드
    _userName = user.user_name;
    _userTel = user.user_tel;
    _userHp = user.user_hp;
    _userCash = user.user_cash;

    // === Pet === //
    _itemId = pet.id;
    _petExp = pet.petExp!;
    _petName = pet.name;

    notifyListeners();
  }
}
