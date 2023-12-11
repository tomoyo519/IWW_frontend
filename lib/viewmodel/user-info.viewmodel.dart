import 'dart:convert';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/model/user/attendance.model.dart';
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
  Item _mainPet;
  Rewards? _reward;
  UserModel _user;
  List<UserAttandance> _attendances;
  final UserRepository _repository;

  UserInfo(
    this._user,
    this._mainPet,
    this._repository,
    this._reward,
    this._attendances,
  ) {
    // FIXME: 업적 달성 모달 항상 뜨도록 설정
    // _reward = Rewards(
    //   achiName: '첫 로그인',
    //   achiDesc: 'achiDesc',
    //   isHidden: false,
    //   achiImg: 'assets/achi/login.png',
    // );
    _setUserState(_user, _mainPet, reward: _reward, attd: _attendances);
  }

  // === Status === //
  late String _userName;
  late String _userTel;
  late int _userHp;
  late int _userCash;

  late int _itemId;
  late int? _petExp;
  late String? _petName;
  late String _itemName;

  // === Getters === //
  Item get mainPet => _mainPet;
  UserModel get userModel => _user;
  List<String> get attendance =>
      _attendances.map((e) => e.day_of_week.toString()).toList();

  int get userId => _user.user_id;
  String get userName => _userName;
  String get userTel => _userTel;
  String? get itemName => _itemName;

  int get userCash => _userCash;
  int get userHp => _userHp;
  int get itemId => _itemId;
  int? get petExp => _petExp;
  String? get mainPetName => _petName;

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

  set petExp(int? exp) {
    _petExp = exp;
    notifyListeners();
  }

  set userCash(int cash) {
    _userCash = cash;
    notifyListeners();
  }

  // 유저 정보 갱신 (초기 로그인시 작동)
  Future<void> fetchUser() async {
    GetUserResult? fetched = await _repository.getUser();
    if (fetched != null) {
      _setUserState(fetched.user, fetched.pet);
      LOG.log("Fetched user state.");
    }
  }

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
        if (res.statusCode == 200) {
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
      _onTodoReward(prevUserCash);
    }
  }

  // 다른 유저에 의해 그룹 인증이 체크 완료된 경우
  Future<void> handleGroupCheck({Map<String, dynamic>? message}) async {
    int prevPetId = _itemId;
    int prevUserCash = _userCash;

    // 1. 인증 정보가 있는 경우
    //    현재 펫의 정보를 담아서 그룹 인증 완료 이벤트 발행
    if (message != null) {
      message['item_path'] = _mainPet.path;
      _onTodoApproved(jsonEncode(message));
    }

    // 2. 새로운 유저 정보 fetch for 진화 확인
    //    TODO: 펫 및 업적 정보만 fetch해오도록 변경
    await fetchUser();

    // 3. 업적 또는 진화 이벤트 확인
    _onTodoReward(prevUserCash);
    _onEvolution(prevPetId);
  }

  // Fetch해온 유저 정보를 상태로 세팅
  void _setUserState(UserModel newUser, Item newPet,
      {Rewards? reward, List<UserAttandance>? attd}) {
    // * Set new user info * //
    _user = newUser;
    _userName = newUser.user_name;
    _userTel = newUser.user_tel;
    _userHp = newUser.user_hp;
    _userCash = newUser.user_cash;

    // * Set new pet info * //
    _mainPet = newPet;
    _itemId = newPet.id;
    _petExp = newPet.petExp;
    _itemName = newPet.name;
    _petName = newPet.petName ?? '';

    // * Set other info * //
    _reward = reward;
    if (attd != null) {
      _attendances = attd;
    }
    notifyListeners();
  }

  // 로그인되자마자 트리거되어야 하는 이벤트들
  void initEvents() {
    _onLoginReward(_reward);

    // Map<String, dynamic> json = {
    //   'message': '인증이 완료되었어요',
    //   'item_path': 'chinese_dragon.gif',
    // };
    // _onTodoApproved(jsonEncode(json));
  }

  // 그룹 인증이 완료된 경우
  void _onTodoApproved(String message) {
    EventService.publish(Event(
      type: EventType.onTodoApproved,
      message: message,
    ));
  }

  // 첫 투두 체크 이벤트
  void _onTodoReward(int prevUserCash) {
    int reward = _userCash - prevUserCash;
    if (reward == RewardService.FIRST_TODO_REWARD) {
      EventService.publish(Event(
        type: EventType.onFirstTodoDone,
      ));
    }
  }

  // 펫 진화 이벤트
  void _onEvolution(int prevPetId) {
    if (prevPetId != _mainPet.id) {
      EventService.publish(Event(
        type: EventType.onPetEvolve,
      ));
    }
  }

  // 로그인 이벤트
  void _onLoginReward(Rewards? reward) {
    if (reward == null || reward.isHidden == true) return;

    var message = jsonEncode(reward.toMap());
    EventService.publish(Event(
      type: EventType.onAchieve,
      message: message,
    ));
    // 앱 사용중 다시 뜨기 방지
    _reward = null;
  }
}
