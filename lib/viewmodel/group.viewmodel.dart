import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';

// 그룹 리스트 화면의 상태를 관리
class GroupViewModel extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final Group _groupList;
  final AuthService _authService;
  GroupViewModel(
    this._groupRepository,
    this._groupList,
    this._authService,
  ) : _groupData = _groupList.toMap() ?? <String, dynamic>{};

  Map<String, dynamic> _groupData;
  Map<String, dynamic> get groupData => _groupData;

  List<dynamic> groups = [];
  bool waiting = true;
  bool _isDisposed = false;

  Future<void> fetchGroupList() async {
    try {
      int? userId = _authService.user?.user_id;
      groups = (await _groupRepository.getMyGroupList(userId)) ?? [];
      waiting = false;
    } catch (err) {
      waiting = false;
      groups = [];
    } finally {
      if (!_isDisposed) {
        waiting = false;
        notifyListeners();
      }
    }
  }
}
