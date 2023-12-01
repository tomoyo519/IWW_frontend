// 투두 에디팅 화면의 상태를 관리
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';

class EditorModalViewModel extends ChangeNotifier {
  final Todo? of; // 초기화된 투두 데이터
  final UserInfo user;
  final BaseTodoViewModel parent;

  EditorModalViewModel({
    this.of,
    required this.user,
    required this.parent,
  }) : _todoData = of?.toMap() ?? <String, dynamic>{};

  // 폼 상태 관리
  Map<String, dynamic> _todoData;
  Map<String, dynamic> get todoData => _todoData;

  // Start Time
  TimeOfDay _timeOfDay = TimeOfDay.now();
  int get hour => _timeOfDay.hour;
  int get min => _timeOfDay.minute;

  // Is Routine?
  String? _todoRoutine;
  String? get todoRoutine => _todoRoutine;

  // Setters
  set todoDate(String val) {
    _todoData['todo_date'] = val;
    notifyListeners();
  }

  set todoLabel(int val) {
    _todoData['todo_label'] = val;
    notifyListeners();
  }

  set todoDone(bool val) {
    _todoData['todo_done'] = val;
    notifyListeners();
  }

  set todoStart(TimeOfDay val) {
    _timeOfDay = val;
    _todoData['todo_start'] = val;
    notifyListeners();
  }

  set todoDesc(String val) {
    _todoData['todo_desc'] = val;
    notifyListeners();
  }

  set todoRoutine(String? val) {
    _todoRoutine = val;
    notifyListeners();
  }

  // 할일 저장
  Future<bool> createTodo() async {
    LOG.log("todo_editor.viewmodel.dart createTodo 실행");
    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    todoData['user_id'] = user.userId;
    todoData['todo_start'] = timeString;

    // 상위 뷰모델의 함수를 불러
    return await parent.createTodo(todoData);
  }

  // 할일 수정
  Future<bool> updateTodo() async {
    var id = todoData["todo_id"];

    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    todoData['todo_start'] = timeString;
    return await parent.updateTodo(id.toString(), todoData);
  }
}
