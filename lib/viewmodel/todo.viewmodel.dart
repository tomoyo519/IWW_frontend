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
  final Todo? _todo; // 초기화된 투두 데이터

  TodoEditorViewModel(
    this._todoRepository,
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
  Future<bool> createTodo(int userId) async {
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
    todoData['user_id'] = userId;
    todoData['todo_start'] = timeString;
    LOG.log("$todoData");
    return await _todoRepository.createTodo(todoData);
  }

  // 할일 수정
  Future<bool> updateTodo() async {
    var id = todoData["todo_id"];

    print(' 🤔🤔🤔🤔 $todoData');
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
    return await _todoRepository.updateTodo(id.toString(), todoData);
  }
}

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository;
  final AuthService _authService;

  // 생성자
  TodoViewModel(this._todoRepository, this._authService) {
    fetchTodos();
  }

  List<Todo> todos = [];
  bool waiting = true;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // 할일 목록 가져오기
  Future<void> fetchTodos() async {
    try {
      int? userId = _authService.user?.user_id;
      todos = (await _todoRepository.getTodos(userId)) ?? [];
      waiting = false;
    } catch (error) {
      LOG.log("fetch error $error");
      waiting = false;
      todos = [];
    } finally {
      if (!_isDisposed) {
        waiting = false;
        notifyListeners();
      }
    }
  }

  // 할일 완료
  Future<bool> checkTodo(int todoId, bool checked) async {
    return await _todoRepository.checkTodo(todoId.toString(), checked);
  }

  // 할일 삭제
  Future<bool> deleteTodo(int todoId) async {
    return await _todoRepository.deleteTodo(todoId.toString());
  }

  //할일 완료

  Future<bool> checkTodo(
      int userId, int todoId, bool checked, String path) async {
    return await _todoRepository.checkTodo(
        userId.toString(), todoId.toString(), checked, path);
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
