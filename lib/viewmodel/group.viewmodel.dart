import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';

// 그룹 리스트 화면의 상태를 관리
class MyGroupViewModel extends ChangeNotifier {
  final GroupRepository _groupRepository;
  final AuthService _authService;

  MyGroupViewModel(
    this._groupRepository,
    this._authService,
  ) {
    fetchMyGroupList();
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
      int? userId = _authService.user?.user_id;
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
}

//그룹의 상세 화면의 상태를 관리

class GroupDetailModel extends ChangeNotifier {
  final GroupRepository _groupRepository;

  GroupDetailModel(this._groupRepository) {
    fetchMyGroupList();
  }

  List<GroupDetail> groupDetail = [];
  bool waiting = true;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchMyGroupList() async {
    try {
      groupDetail = (await _groupRepository.getGroupDetail(1) ?? []);

      waiting = false;
    } catch (err) {
      waiting = false;
      groupDetail = [];
    } finally {
      notifyListeners();
      waiting = false;
      if (!_isDisposed) {}
    }
  }
}
