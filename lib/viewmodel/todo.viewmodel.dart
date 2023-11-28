import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository;
  final UserInfo _user;

  // 생성자
  TodoViewModel(this._todoRepository, this._user) {
    fetchTodos();
  }

  // 자원해제
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ===== Status ===== //
  List<Todo> _todos = [];
  bool _waiting = true;
  bool _isDisposed = false;
  int _exp = 0;
  bool _isTodaysFirstTodo = false;

  // ===== Status Getters ===== //
  List<Todo> get todos => _todos;
  bool get waiting => _waiting;
  int get total => _todos.length;
  int get check => _todos.where((e) => e.todoDone == true).length;
  int get exp => _exp;
  bool get isTodaysFirstTodo => _isTodaysFirstTodo;

  // ===== Status Setters ===== //
  set isTodaysFirstTodo(bool val) => _isTodaysFirstTodo = val;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // 할일 목록 가져오기
  Future<void> fetchTodos() async {
    int userId = _user.user_id;
    // 상태 업데이트
    _todos = await _todoRepository.getTodos(userId);
    waiting = false;
  }

  // 할일 삭제하고 목록 업데이트
  Future<bool> deleteTodo(int todoId) async {
    waiting = true;
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

  // 할일 완료하고 목록 업데이트
  Future<bool> checkTodo(Todo todo, bool checked,
      {int? userId, String? path}) async {
    // waiting = true;

    if (path == null) {
      // 만약 이미지 경로가 없으면 일반 할일 체크로 처리합니다.
      return _checkNormalTodo(todo, checked);
    }
    // 이미지 경로가 있으면 그룹 할일 체크로 처리합니다.
    return await _todoRepository.checkGroupTodo(
      userId.toString(),
      todo.todoId.toString(),
      checked,
      path,
    );
  }

  Future<bool> _checkNormalTodo(Todo todo, bool checked) async {
    return await _todoRepository
        .checkNormalTodo(todo.todoId.toString(), checked)
        .then((value) {
      if (value = true) {
        // 업데이트에 성공한 경우 할일 리스트 상태에서도 동일하게 처리
        int idx = _todos.indexWhere((e) => e.todoId == todo.todoId);
        if (idx != -1) {
          var today = DateFormat('yyyy-MM-dd').format(DateTime.now());

          // 오늘 완료한 투두 개수
          var todaysCheckedTodo = _todos
              .where((e) => e.todoDate == today && e.todoDone == true)
              .length;

          // 아직 첫 투두 완료 모달창이 안 떴고
          // 오늘의 첫 투두를 완료한 경우,
          if (!isTodaysFirstTodo && todaysCheckedTodo == 0) {
            // 모달창을 띄웁니다
            _isTodaysFirstTodo = true;
          }

          _todos[idx].todoDone = checked;

          // TODO: User 쪽으로 옮기기
          _exp = min(_exp + 5, 50);
        }
        waiting = false;
        return idx != -1;
      }
      waiting = false;
      return false;
    });
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
