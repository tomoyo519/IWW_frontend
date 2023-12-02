import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';

// == 전역 유저 상태 관리 == //
class UserInfo extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _repository;
  UserModel _user;

  UserInfo(
    this._authService,
    this._repository,
    this._user,
  ) {
    _userName = _user.user_name;
    _userTel = _user.user_tel;
    _userHp = _user.user_hp;

    _userCash = _user.user_cash;
    _loginCnt = user.login_cnt;

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
  late int _loginCnt;

  late int _mainPet;
  late int _mainPerLv;
  late int _mainPetExp;
  late String _mainPetName;

  // === Getters === //
  UserModel get user => _user;
  int get userId => _user.user_id;
  String get userName => _user.user_name;

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

  ///** Event Listener
  /// 다른 뷰모델로부터 유저 상태를
  /// 업데이트해야 할 필요가 있음을 알림받습니다.
  /// 서비스 서버의 User Table이 업데이트된 경우
  /// _fetchUser로 다시 정보를 받아옵니다.
  /// */
  void listenEvents() {
    EventService.stream.listen((event) async {
      if (event.type == EventType.status) {
        UserModel prev = _user;
        await _fetchUser();

        UserModel curr = _user;
        _triggerEvent(prev, curr);
      }
    });
  }

  // ==== CRUD ==== //
  Future<void> _fetchUser() async {
    UserModel? fetched = await _repository.getUser();
    if (fetched == null) {
      _authService.user = null; // 인가 정보를 삭제
      return;
    }
    _user = fetched;
  }

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

  // ==== 유저 정보 변경에 따른 이벤트 트리거 ==== //
  void _triggerEvent(UserModel prev, UserModel curr) {
    // 캐시 업데이트 이벤트
    int cash = curr.user_cash - prev.user_cash;
    if (cash == 100) {
      // EventService.publish(event)
      EventService.publish(Event(
        type: EventType.show_first_todo_modal,
        message: "첫 할일 달성 완료!",
      ));
    } else {
      bool value = cash > 0;
      EventService.publish(Event(
        type: EventType.show_todo_snackbar,
        message: "할일을 ${value ? "달성" : "취소"}했어요! $cash",
      ));
    }

    // 펫 진화 이벤트
  }
}
