import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/utils/logger.dart';

// 그룹 리스트 화면의 상태를 관리
class MyGroupViewModel extends ChangeNotifier {
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

  String? _groupRoutine;
  String? get groupRoutine => _groupRoutine;

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

  set groupRoutine(String? val) {
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
      var json = {
        "grpInfo": (groupData),
        "routInfo": groupRoutine ??
            [
              {
                "rout_name": "아침에 일어나기",
                "rout_desc": "이부자리 정리하기",
                "rout_repeat": 1111100,
                "rout_srt": "200000",
                "rout_end": "200000"
              }
            ]
      };
      LOG.log('json: $json');
      groupData["user_id"] = "1";

      var rest = (await _groupRepository.createOne(json) ?? []);
      LOG.log('rest:$rest');
      return true;
    } catch (err) {
      LOG.log('err:$err');
      return false;
    }
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
