import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier implements BaseTodoViewModel {
  final TodoRepository _todoRepository;
  final int _userId;

  // 생성자
  TodoViewModel(this._todoRepository, this._userId) {
    fetchTodos();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ****************************** //
  // *        View States         * //
  // ****************************** //
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  List<Todo> _normalTodos = [];
  List<Todo> get normalTodos => _normalTodos;

  List<Todo> _groupTodos = [];
  List<Todo> get groupTodos => _groupTodos;

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  String _selectedDate = '';
  String get selectedDate => _selectedDate;
  void setSelectedDate(String newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  var _selectedLabel = 0;
  int get selectedLabel => _selectedLabel;
  void setSelectedLabel(int labelNo) {
    _selectedLabel = labelNo;
    notifyListeners();
  }

  TimeOfDay _selectedAlarmTime = TimeOfDay.now();
  TimeOfDay get selectedAlarmTime => _selectedAlarmTime;
  void setSelectedAlarmTime(dynamic alarmTime) {
    _selectedAlarmTime = alarmTime;
    notifyListeners();
  }

  int _todayDone = 0;
  int get check => _todayDone;

  int _todayTotal = 0;
  int get total => _todayTotal;

  bool _isDisposed = false;

  // ****************************** //
  // *         Fetch Data         * //
  // ****************************** //
  Future<void> fetchTodos() async {
    waiting = true;

    // 상태 업데이트
    var data = await _todoRepository.getTodos(_userId);

    // 분리해서 가져오기
    _todos = data;
    _normalTodos = data.where((todo) => todo.grpId == null).toList();
    _groupTodos = data.where((todo) => todo.grpId != null).toList();

    // 카운트
    _todayDone = data.where((todo) => todo.todoDone == true).length;
    _todayTotal = data.length;

    LOG.log("Fetched data group todo ${data.length}");
    waiting = false;
  }

  // ****************************** //
  // *        Create Data         * //
  // ****************************** //
  @override
  Future<bool> createTodo(Map<String, dynamic> data) async {
    Todo? todo = await _todoRepository.createTodo(data);
    bool result = false;

    if (todo != null) {
      _normalTodos.add(todo);
      result = true;
      waiting = false;

      EventService.publish(
        Event(
          type: EventType.show_todo_snackbar,
          message: "새로운 할일이에요!",
        ),
      );
    }
    waiting = false;
    return result;
  }

  // ****************************** //
  // *        Delete Data         * //
  // ****************************** //

  Future<bool> deleteTodo(int todoId) async {
    _todos = _todos.where((todo) => todo.todoId != todoId).toList();
    waiting = false; // 상태부터 변경합니다

    return await _todoRepository.deleteTodo(todoId.toString()).then((value) {
      if (value == true) {
        EventService.publish(
          Event(
            type: EventType.show_todo_snackbar,
            message: "할일을 삭제했어요!",
          ),
        );
        return true;
      }
      return false;
    });
  }

  // ****************************** //
  // *        Update Data         * //
  // ****************************** //

  // 할일 상태를 완료됨으로 변경합니다.
  void checkTodoState(Todo todo, bool value, int? userId, String? path) {
    int idx = _todos.indexWhere((e) => e.todoId == todo.todoId);
    if (idx == -1) {
      // 투두가 없는 경우
      LOG.log("Failed to find todo by id in todos list");
      waiting = false;
    } else {
      // 개인 투두인 경우
      _todos[idx].todoDone = value;
      waiting = false;
    }
  }

  // 개인 투두에 대한 완료 처리
  Future<TodoCheckDto?> checkNormalTodo(int todoId, bool value) async {
    String todoIdStr = todoId.toString();
    return await _todoRepository.checkNormalTodo(todoIdStr, value);
  
  Future<bool?> checkTodo(int todoId, bool value,
      {int? userId, String? path}) async {
    if (userId == null || path == null) {
      // return await _todoRepository.checkNormalTodo(todoId.toString(), value);
      return false;
    }

    return await _todoRepository.checkGroupTodo(
        userId.toString(), todoId.toString(), value, path);
  }

  Future<bool?> checkTodo(
    int todoId,
    bool value, {
    int? userId,
    String? path,
  }) async {
    return await _todoRepository.checkGroupTodo(
        userId.toString(), todoId.toString(), value, path!);
  }

  @override
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    waiting = true;
    return await _todoRepository.updateTodo(id, data).then(
      (updated) {
        if (updated != null) {
          int idx = _todos.indexWhere((todo) => todo.todoId.toString() == id);
          _todos[idx] = updated;
          waiting = false;

          EventService.publish(
            Event(
              type: EventType.show_todo_snackbar,
              message: "할일을 수정했어요!",
            ),
          );
          return true;
        }
        waiting = false;
        return false;
      },
    );
  }
}
