import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';

// 투두 에디팅 화면의 상태를 관리
class TodoEditorViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository;
  final AuthService _authService;
  final Todo? _todo; // 초기화된 투두 데이터

  TodoEditorViewModel(
    this._todoRepository,
    this._authService,
    this._todo,
  ) : _todoData = _todo?.toMap() ?? <String, dynamic>{};

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

    Map<String, dynamic> data = {
      "user_id": 6,
      "todo_name": todoData['todo_name'],
      "todo_done": false,
      "todo_desc": todoData['todo_desc'],
      "todo_label": todoData['todo_label'],
      "todo_start": timeString,
    };
    return await _todoRepository.createTodo(data);
  }

  // 할일 수정
  Future<bool> updateTodo() async {
    var id = todoData["todo_id"];
    // String timeString = "$hour시 $min분";
    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    Map<String, dynamic> data = {
      "user_id": 6,
      "todo_name": todoData['todo_name'],
      "todo_done": false,
      "todo_desc": todoData['todo_desc'],
      "todo_label": todoData['todo_label'],
      "todo_start": timeString,
    };

    return await _todoRepository.updateTodo(id.toString(), data);
  }
}

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository;
  final AuthService _authService;

  // 생성자
  TodoViewModel(this._todoRepository, this._authService);

  List<Todo> todos = [];

  // 할일 가져오기
  Future fetchTodos() async {
    try {
      todos = await _todoRepository.getTodos(null) ?? [];
      notifyListeners();
    } catch (error) {
      LOG.log("fetch error $error");

      print('wow');
      log("fetch error $error");
    }
  }

  // 할일 삭제
  Future<bool> deleteTodo(int todoId) async {
    return await _todoRepository.deleteTodo(todoId.toString());
  }

  String _selectedDate = '';
  var _selectedLabel = 0;
  TimeOfDay _selectedAlarmTime = TimeOfDay.now();
  String get selectedDate => _selectedDate;
  int get selectedLabel => _selectedLabel;
  TimeOfDay get selectedAlarmTime => _selectedAlarmTime;

  void setSelectedDate(String newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void setSelectedLabel(int labelNo) {
    _selectedLabel = labelNo;
    notifyListeners();
  }

  void setSelectedAlarmTime(dynamic alarmTime) {
    _selectedAlarmTime = alarmTime;
    notifyListeners();
  }
}
