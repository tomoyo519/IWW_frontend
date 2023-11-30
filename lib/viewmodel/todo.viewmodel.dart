import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/base_todo.viewmodel.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/utils/logger.dart';

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier implements BaseTodoViewModel {
  final TodoRepository _todoRepository;
  final UserInfo _user;

  // 생성자
  TodoViewModel(this._todoRepository, this._user) {
    fetchTodos();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ===== Status ===== //
  List<Todo> _todos = [];
  List<Todo> _groupTodos = [];
  bool _waiting = true;
  bool _isDisposed = false;
  bool _isTodaysFirstTodo = false;
  bool _notifyUser = false;

  // ===== Status Getters ===== //
  List<Todo> get todos => _todos;
  List<Todo> get groupTodos => _groupTodos;
  bool get waiting => _waiting;
  int get total => _todos.length + _groupTodos.length;
  int get check =>
      _todos.where((e) => e.todoDone == true).length +
      _groupTodos.where((e) => e.todoDone == true).length;
  bool get isTodaysFirstTodo => _isTodaysFirstTodo;
  bool get notifyUser => _notifyUser;

  // ===== Status Setters ===== //
  set notifyUser(bool val) => _notifyUser = val;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> setTodos() async {}

  // ****************************** //
  // *         Fetch Data         * //
  // ****************************** //
  Future<void> fetchTodos() async {
    // 상태 업데이트
    int userId = _user.user_id;
    var data = await _todoRepository.getTodos(userId);

    // 분리해서 가져오기
    _todos = data.where((todo) => todo.grpId == null).toList();
    _groupTodos = data.where((todo) => todo.grpId != null).toList();
    waiting = false;
  }

  // ****************************** //
  // *        Delete Data         * //
  // ****************************** //

  // 할일 삭제하고 목록 업데이트
  Future<bool> deleteTodo(int todoId) async {
    // waiting = true;
    return await _todoRepository.deleteTodo(todoId.toString()).then((value) {
      if (value == true) {
        _todos = _todos.where((todo) => todo.todoId != todoId).toList();
        waiting = false;
        return true;
      }
      waiting = false;
      return false;
    });
  }

  // ****************************** //
  // *        Update Data         * //
  // ****************************** //

  // 할일 완료하고 목록 업데이트
  Future<bool> checkTodo(Todo todo, bool checked,
      {int? userId, String? path}) async {
    // waiting = true;

    LOG.log("check todo");

    if (path == null) {
      // 만약 이미지 경로가 없으면 일반 할일 체크로 처리합니다.
      return _checkNormalTodo(todo, checked);
    }
    // 이미지 경로가 있으면 그룹 할일 체크로 처리합니다.
    return await _checkGroupTodo(userId, todo, checked, path);
  }

  // 오늘 기준으로 완료된 할일 개수를 리턴
  int getTodaysChecked(DateTime now) {
    final today = DateFormat('yyyy-MM-dd').format(now);
    return _todos
        .where((e) => e.todoDate == today && e.todoDone == true)
        .length;
  }

  // ****************************** //
  // *         Fetch Data         * //
  // ****************************** //

  // 기본 할일 체크
  Future<bool> _checkNormalTodo(Todo todo, bool checked) async {
    // return _updateTodoStatus(true, todo, checked);
    return await _todoRepository
        .checkNormalTodo(todo.todoId.toString(), checked)
        .then((value) => _updateTodoStatus(value, todo, checked));
  }

  // 그룹 할일 체크
  Future<bool> _checkGroupTodo(
      int? userId_, Todo todo, bool checked, String path) async {
    var userId = userId_.toString();
    var todoId = todo.todoId.toString();
    return await _todoRepository
        .checkGroupTodo(userId, todoId, checked, path)
        .then((value) => _updateTodoStatus(value, todo, checked));
  }

  // 할일 리스트에서 상태 갱신
  Future<bool> _updateTodoStatus(bool value, Todo todo, bool checked) async {
    if (!value) {
      waiting = false;
      return false;
    }

    LOG.log("Update group todo status $value");
    int idx = _todos.indexWhere((e) => e.todoId == todo.todoId);
    if (idx != -1) {
      _checkIfFirstTodo(todo, checked);
      _todos[idx].todoDone = checked;
    }

    waiting = false;
    return idx != -1;
  }

  // 업데이트에 성공한 경우 할일에 따른 보상 처리
  void _checkIfFirstTodo(Todo todo, bool checked) {
    final now = DateTime.now();
    // 오늘 완료한 투두 개수
    int todaysDone = getTodaysChecked(now);

    if (checked == true && todaysDone == 0) {
      // 아직 첫 투두 완료 모달창이 안 떴고
      // 오늘의 첫 투두를 완료한 경우,
      // 모달창을 띄웁니다
      _notifyUser = true;
      _isTodaysFirstTodo = true;
    } else if (checked == false && todaysDone == 1) {
      // 마지막으로 체크되어있던 투두를 취소하는 경우
      // 유저 캐시를 -100
      _notifyUser = true;
      _isTodaysFirstTodo = false;
    }
  }

  // === Calendar Status === //
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

  @override
  Future<bool> createOne(Map<String, dynamic> data) {
    // 데이터를 받아서 todo에 셋하고 리포지토리로 넘김
    // TODO: implement createOne
    throw UnimplementedError();
  }

  @override
  Future<bool> updateOne(String id, Map<String, dynamic> data) {
    // 데이터를 받아서 todo에 셋하고 리포지토리로 넘김
    // TODO: implement updateOne
    throw UnimplementedError();
  }
}
