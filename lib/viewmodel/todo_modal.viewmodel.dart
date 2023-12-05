// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/loading.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

class TodoModalViewModel extends ChangeNotifier {
  final Todo? todo;

  TodoModalViewModel({
    this.todo,
  }) {
    // set state
    if (todo != null) {
      _todoName = todo!.todoName;
      _todoLabel = todo!.todoLabel;
      _todoDesc = todo!.todoDesc;
      _todoDone = todo!.todoDone;
      _todoSrt = todo!.todoStart;
      _todoEnd = todo!.todoEnd;
    }
  }

  // * === send request via parent === * //
  Future<bool> create(BuildContext context) async {
    final userId = context.read<UserInfo>().userId;
    final parent = Provider.of<BaseTodoViewModel>(context, listen: false);
    final data = _createData();
    return await parent.createTodo(data);
  }

  // * === pack status as request === * //
  Map<String, dynamic> _createData() {
    return {
      "todo_name": _todoName,
      "todo_desc": _todoDesc,
      "todo_label": _todoLabel,
      "todo_date": nowstring,
      "todo_done": _todoDone,
      "todo_start": _todoSrt,
      "todo_end": _todoEnd,
      "grp_id": null,
      "todo_img": null,
    };
  }

  // * === getters & setters === * //
  String? _todoName;
  String? get name => _todoName;
  set name(String? val) {
    _todoName = val;
    notifyListeners();
  }

  String? _todoDesc;
  String? get desc => _todoDesc;
  set desc(String? val) {
    _todoDesc = val;
    notifyListeners();
  }

  int? _todoLabel;
  int? get label => _todoLabel;
  set label(int? val) {
    _todoLabel = val;
    notifyListeners();
  }

  String get labelStr {
    return (_todoLabel != null) ? LABELS[_todoLabel!] : LABELS[0];
  }

  bool? _todoDone;
  bool? get done => _todoDone;
  set done(bool? val) {
    _todoDone = val;
    notifyListeners();
  }

  String? _todoSrt;
  String? get strtime => _todoSrt;
  set strtime(String? val) {
    _todoSrt = val;
    notifyListeners();
  }

  String? _todoEnd;
  String? get endtime => _todoEnd;
  set endtime(String? val) {
    _todoEnd = val;
    notifyListeners();
  }

  String get nowstring {
    TimeOfDay timeOfDay = TimeOfDay.now();
    String hour = timeOfDay.hour.toString().padLeft(2, '0');
    String min = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour$min:00';
  }

  // * === Visibility === * //
  int _option = -1;
  int get option => _option;
  set option(int val) {
    _option = val;
    notifyListeners();
  }

  // * ==== create button fields ==== * //
  List<ButtonFieldData> fields = [
    ButtonFieldData(
      idx: 0,
      label: "라벨",
      icon: Icons.label_important_outline_rounded,
    ),
    ButtonFieldData(
      idx: 1,
      label: "시간",
      icon: Icons.timer_outlined,
    ),
    ButtonFieldData(
      idx: 2,
      label: "반복",
      icon: Icons.repeat_rounded,
    )
  ];
  final List<String> LABELS = [
    "전체",
    "공부",
    "운동",
    "코딩",
    "게임",
    "명상",
    "모임",
    "학업",
    "자유시간",
    "자기관리",
    "독서",
    "여행",
    "유튜브",
    "약속",
    "산책",
    "집안일",
    "취미",
    "기타",
  ];

  static final List<String> _routines = [
    '매일',
    '평일',
    '주말',
    '매주',
  ];
}

class ButtonFieldData {
  final int idx;
  final String label;
  final IconData icon;

  ButtonFieldData({
    required this.idx,
    required this.label,
    required this.icon,
  });
}
