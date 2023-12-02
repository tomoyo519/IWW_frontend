import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier implements BaseTodoViewModel {
  final TodoRepository _todoRepository;
  final UserModel _user;

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
  Todo? _newTodo;
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

  // 오늘 기준으로 완료된 할일 개수를 리턴
  int getTodaysChecked(DateTime now) {
    final today = DateFormat('yyyy-MM-dd').format(now);
    return _todos
        .where((e) => e.todoDate == today && e.todoDone == true)
        .length;
  }

  // ===== Status Setters ===== //
  set notifyUser(bool val) => _notifyUser = val;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

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
    notifyListeners();
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
  // 전체 투두 비율을 계산해서 리워드 이벤트 트리거
  Future<bool> checkTodo(
    Todo todo,
    bool value, {
    int? userId,
    String? path,
  }) async {
    // 만약 이미지 경로가 없으면 일반 할일 체크로 처리합니다.
    if (userId == null || path == null) {
      return await _todoRepository
          .checkNormalTodo(todo.todoId.toString(), value)
          .then((result) => _updateTodoStatus(result, todo, value));
    }

    // FIXME: 이미지 경로가 있으면 그룹 할일 체크로 처리합니다.
    return false;
    // var todoId = todo.todoId.toString();
    // return await _todoRepository
    //     .checkGroupTodo(userId.toString(), todoId, value, path)
    //     .then((result) => _updateTodoStatus(result, todo, value));
  }

  // 할일 리스트에서 상태 갱신
  Future<bool> _updateTodoStatus(
    TodoUpdateDto? result,
    Todo todo,
    bool value,
  ) async {
    if (result == null) {
      LOG.log("Failed to update todo status.");
      waiting = false;
      return false;
    }

    int idx = _todos.indexWhere((e) => e.todoId == todo.todoId);
    if (idx == -1) {
      LOG.log("Failed to find todo by id in todos list");
      waiting = false;
      return false;
    }

    // todo update 결과를 user model로 전송
    // user info 상태를 fetch 하도록 알림
    EventService.publish(
      Event(type: EventType.status),
    );

    _todos[idx].todoDone = value;
    waiting = false;
    return idx != -1;
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
  Future<bool> createTodo(Map<String, dynamic> data) async {
    waiting = true;
    bool result = await _todoRepository.createTodo(data);
    fetchTodos();
    return result;
  }

  @override
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    waiting = true;
    return await _todoRepository.updateTodo(id, data).then(
      (value) {
        if (value == true) {
          int idx = _todos.indexWhere((todo) => todo.todoId.toString() == id);
          _todos[idx] = Todo.fromJson(data);
          fetchTodos();
          return true;
        }
        fetchTodos();
        return false;
      },
    );
  }
}
