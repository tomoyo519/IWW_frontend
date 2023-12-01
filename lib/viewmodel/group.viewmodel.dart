import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/routine/routine.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';

// 그룹 리스트 화면의 상태를 관리
class MyGroupViewModel extends ChangeNotifier implements BaseTodoViewModel {
  final GroupRepository _groupRepository;
  // final UserInfo? _userInfo;

  MyGroupViewModel(
    this._groupRepository,
    // this._userInfo,
  ) {
    fetchMyGroupList();
  }

  // 폼 상태 관리
  Map<String, dynamic> _groupData = {};
  Map<String, dynamic> get groupData => _groupData;

  List<Routine> _groupRoutine = [];
  List<Routine> get groupRoutine => _groupRoutine;

  set groupDesc(String val) {
    _groupData['grp_decs'] = val;
    notifyListeners();
  }

  set groupCat(int val) {
    _groupData['cat_id'] = val;
    notifyListeners();
  }

  set groupName(String val) {
    _groupData['grp_name'] = val;
    notifyListeners();
  }

  set groupRoutine(List<Routine> val) {
    _groupRoutine = val;
    notifyListeners();
  }

  List<Group> groups = [];
  bool waiting = true;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchMyGroupList() async {
    try {
      // int userId = _userInfo.user_id;
      // TODO - userId 안들어옴;
      // LOG.log('$userId');
      groups = (await _groupRepository.getMyGroupList(1) ?? []);

      waiting = false;
    } catch (err) {
      waiting = false;
      groups = [];
    } finally {
      notifyListeners();
      waiting = false;
      if (!_isDisposed) {}
    }
  }

  Future<bool?> createGroup() async {
    try {
      groupData["user_id"] = 1;
      groupData["cat_id"] = groupData["cat_id"];
      Map<String, dynamic> json = {
        "grpInfo": groupData,
        "routInfo": jsonEncode(groupRoutine.map((e) => e.toJSON()).toList()),
      };

      LOG.log('json: $json');

      bool rest = (await _groupRepository.createTodo(json));
      LOG.log('rest:$rest');
      return true;
    } catch (err) {
      LOG.log('err:$err');
      return false;
    }
  }

  @override
  // EditorModal에서 폼 데이터를 가져와서 상태로 지정
  Future<bool> createTodo(Map<String, dynamic> data) async {
    ;
    Routine routine = Routine.fromTodoJson(data);

    if (_groupRoutine.length < 3) {
      _groupRoutine.add(routine);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  @override
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    int idx = _groupRoutine.indexWhere((rout) => rout.routId.toString() == id);
    if (idx == -1) {
      LOG.log("Error updating routine! not found.");
      return false;
    }
    _groupRoutine[idx] = Routine.fromJson(data);
    return true;
  }
}

//그룹의 상세 화면의 상태를 관리

class GroupDetailModel extends ChangeNotifier {
  final GroupRepository _groupRepository;

  GroupDetailModel(this._groupRepository) {
    fetchMyGroupList();
  }

  GroupDetail? groupDetail;
  List<RouteDetail> routeDetail = [];
  List<GroupMember> grpMems = [];
  bool waiting = true;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchMyGroupList() async {
    try {
      groupDetail =
          (await _groupRepository.getGroupDetail(1) ?? []) as GroupDetail?;
      routeDetail = (await _groupRepository.getRouteDetail(1) ?? []);
      grpMems = (await _groupRepository.getMember(1) ?? []);

      waiting = false;
    } catch (err) {
      waiting = false;
      groupDetail = null;
    } finally {
      notifyListeners();
      waiting = false;
      if (!_isDisposed) {}
    }
  }
}
