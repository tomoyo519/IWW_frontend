// 투두 에디팅 화면의 상태를 관리
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/base_todo.repository.dart';
import 'package:iww_frontend/repository/todo.repository.dart';

class EditorModalViewModel extends ChangeNotifier {
  final Todo? of; // 초기화된 투두 데이터
  final UserInfo user;
  final BaseTodoRepository repository;

  EditorModalViewModel({
    this.of,
    required this.user,
    required this.repository,
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
    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    // Map<String, dynamic> data = {
    //   "user_id": 6,
    //   "todo_name": todoData['todo_name'],
    //   "todo_done": false,
    //   "todo_desc": todoData['todo_desc'],
    //   "todo_label": todoData['todo_label'],
    //   "todo_start": timeString,
    // };
    todoData['user_id'] = user.user_id;
    todoData['todo_start'] = timeString;

    return await repository.createOne(todoData);
  }

  // 할일 수정
  Future<bool> updateTodo() async {
    var id = todoData["todo_id"];

    // String timeString = "$hour시 $min분";
    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    // Map<String, dynamic> data = {
    //   "user_id": todoData["user_id"],
    //   "todo_name": todoData['todo_name'],
    //   "todo_done": false,
    //   "todo_desc": todoData['todo_desc'],
    //   "todo_label": todoData['todo_label'],
    //   "todo_start": timeString,
    // };

    todoData['todo_start'] = timeString;
    return await repository.updateOne(id.toString(), todoData);
  }
}
