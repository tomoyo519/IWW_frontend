import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';

// 전체 투두리스트 상태를 관리
class TodoViewModel extends ChangeNotifier implements BaseTodoViewModel {
  final int _userId;
  final TodoRepository _repository;

  // 생성자
  TodoViewModel(this._repository, this._userId) {
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

  // 1. 전체 투두
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  // 2. 개인 투두
  List<Todo> _normalTodos = [];
  List<Todo> get normalTodos => _normalTodos;

  // 3. 그룹 투두
  List<Todo> _groupTodos = [];
  List<Todo> get groupTodos => _groupTodos;

  // 4. 기한이 지난 개인투두
  List<Todo> _prevTodos = [];
  List<Todo> get prevTodos => _prevTodos;

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  int get todayDone {
    return _todos.where((todo) {
      return todo.isDone && todo.todoDate == getToday();
    }).length;
  }

  int get todayTotal {
    return _todos.where((todo) {
      return todo.todoDate == getToday();
    }).length;
  }

  bool _isDisposed = false;

  // ****************************** //
  // *         Fetch Data         * //
  // ****************************** //

  Future<void> fetchTodos() async {
    waiting = true;

    // 상태 업데이트
    var data = await _repository.getTodos(_userId);

    // 분리해서 가져오기
    _todos = data;
    _normalTodos = data.where((todo) => todo.grpId == null).toList();
    _groupTodos = data.where((todo) => todo.grpId != null).toList();
    _prevTodos = _normalTodos
        .where((todo) => todo.todoDate.compareTo(getToday()) < 0)
        .toList();

    LOG.log("Fetched data group todo ${data.length}");
    waiting = false;
  }

  // ****************************** //
  // *        Create Data         * //
  // ****************************** //

  @override
  Future<bool> createTodo(Map<String, dynamic> data) async {
    Todo? todo = await _repository.createTodo(data);
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

  Future<bool> deleteTodo(Todo delTodo) async {
    _todos = _todos.where((todo) => todo.todoId != delTodo.todoId).toList();
    waiting = false; // 상태부터 변경합니다

    return await _repository
        .deleteTodo(delTodo.todoId.toString())
        .then((value) {
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
    return await _repository.checkNormalTodo(todoIdStr, value);
  }

  Future<bool?> checkGroupTodo(int todoId, int userId, String path) async {
    return await _repository.checkGroupTodo(userId, todoId, path);
  }

  @override
  Future<bool> updateTodo(String userId, Map<String, dynamic> data) async {
    int todoId = data['todo_id'];
    Todo? updated = await _repository.updateTodo(userId, data);
    if (updated != null) {
      int idx = _todos.indexWhere((t) => t.todoId == todoId);
      LOG.log(jsonEncode(data));
      LOG.log(jsonEncode(updated.toMap()));
      _todos[idx] = updated;
    }

    waiting = false;
    return true;
  }

  String getToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
