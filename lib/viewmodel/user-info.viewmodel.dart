import 'dart:convert';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
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
    // initialize
    _setUserState(_user, _mainPet);
  }

  // === Status === //
  late String _userName;
  late String _userTel;
  late int _userHp;
  late int _userCash;

  late int _itemId;
  late int _petExp;
  late String _petName;
  late String _itemName;

  // === Getters === //
  UserModel get userModel => _user;
  int get userId => _user.user_id;
  String get userName => _userName;
  String get userTel => _userTel;
  String get itemName => _itemName;

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
    GetUserResult? fetched = await _repository.getUser();
    if (fetched == null) {
      // _authService.user = null; // 인가 정보를 삭제
      return;
    }
    // 유저의 상태 정보를 세팅하고 notify합니다.
    _setUserState(fetched.user, fetched.pet);
  }

  // TODO type 달기
  Future<bool> reNameUser(myname, userInfo) async {
    try {
      var json = {
        "user_name": myname,
        "user_tel": userInfo._userTel,
        "user_kakao_id": userInfo.userModel.user_kakao_id
      };
      LOG.log('왜안찍혀????? $json');
      return await RemoteDataSource.put('/user/${userInfo.userId}',
              body: jsonEncode(json))
          .then((res) {
        LOG.log('${res.statusCode}');
        if (res.statusCode == 200 && res != null) {
          userName = myname;
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      LOG.log(e.toString());
      return false;
    }
  }

  // 개인 할일 체크에 따른 보상 상태 적용하고
  // 첫 투두인 경우 리워드 관련 모달을 띄웁니다.
  void handleTodoCheck(TodoCheckDto dto) {
    int prevUserCash = _userCash;

    if (userId == dto.userId) {
      _userCash = dto.userCash;
      notifyListeners();
      onTodoReward(prevUserCash);
    }
  }

  // Fetch해온 유저 정보를 상태로 세팅하고
  // 관련 이벤트를 트리거합니다.
  void _setUserState(UserModel newUser, Item newPet) {
    UserModel prevUser = _user;
    Item prevPet = _mainPet;

    // * Set new user info * //
    _userName = newUser.user_name;
    _userTel = newUser.user_tel;
    _userHp = newUser.user_hp;
    _userCash = newUser.user_cash;

    // * Set new pet info * //
    _itemId = newPet.id;

    // FIXME: 펫 타입으로 응답이 올 경우 경험치가 같이 와야함
    _petExp = newPet.petExp ?? 0;
    _petName = newPet.petName ?? '';
    _itemName = newPet.name;

    // * Trigger events * //
    onLoginReward(newUser.login_cnt);
    onTodoReward(prevUser.user_cash);
    onEvolution(prevPet.id);

    notifyListeners();
  }

  // 첫 투두 체크 이벤트
  void onTodoReward(int prevUserCash) {
    int reward = _userCash - prevUserCash;
    LOG.log(emoji: 2, '$reward');
    if (reward == RewardService.FIRST_TODO_REWARD) {
      EventService.publish(
        Event(
          type: EventType.show_first_todo_modal,
        ),
      );
    }
  }

  // 펫 진화 이벤트
  void onEvolution(int prevPetId) {
    if (prevPetId != _mainPet.id) {
      EventService.publish(Event(
        type: EventType.show_pet_evolve,
      ));
    }
  }

  // FIXME: DB에 체크하기.
  bool isLoginEventShown = false;

  // 로그인 이벤트
  void onLoginReward(int loginCnt) {
    int idx = RewardService.LOGIN_REWARD.indexOf(loginCnt);
    if (idx < 0) return; // 리워드에 해당하는 카운트가 아님

    if (isLoginEventShown == false) {
      int reward = RewardService.LOGIN_REWARD[idx];

      EventService.publish(Event(
        type: EventType.show_login_achieve,
        message: "로그인 카운트 $reward회 달성!",
      ));
      isLoginEventShown = true;
    }
  }
}
