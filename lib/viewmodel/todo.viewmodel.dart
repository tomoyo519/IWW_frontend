import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/categories.dart';
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

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  int _todayDone = 0;
  int get todayDone {
    // return _todayDone;
    var normalLen = _normalTodos.where((todo) {
      return todo.isDone && todo.todoDate == getToday();
    }).length;
    var groupLen = _groupTodos.where((todo) {
      return todo.isDone && todo.todoDate == getToday();
    }).length;

    return normalLen + groupLen;
    // return _todos.where((todo) {
    //     return todo.isDone && todo.todoDate == getToday();
    //   }).length;
  }

  set todayDone(int val) {
    _todayDone = val;
    notifyListeners();
  }

  int _todayTotal = 0;
  int get todayTotal {
    // return _todayTotal;
    // return _todos.where((todo) {
    //   return todo.todoDate == getToday();
    // }).length;

    var normalLen = _normalTodos.where((todo) {
      return todo.todoDate == getToday();
    }).length;
    var groupLen = _groupTodos.where((todo) {
      return todo.todoDate == getToday();
    }).length;

    return normalLen + groupLen;
  }

  set todayTotal(int val) {
    _todayTotal = val;
    notifyListeners();
  }

  bool _isDisposed = false;

  // ****************************** //
  // *         Fetch Data         * //
  // ****************************** //

  Future<void> fetchTodos() async {
    waiting = true;

    // 상태 업데이트
    Map<String, List<Todo>> data = await _repository.getTodos(_userId);

    // 분리해서 가져오기
    _normalTodos = data['normal']!;
    _groupTodos = data['group']!;
    _todos = _normalTodos + _groupTodos;

    var todayTodo = _todos.where((todo) {
      return todo.todoDate == getToday();
    });

    // TODO 수정필요
    _todayTotal = todayTodo.length;
    _todayDone = todayTodo.where((todo) => todo.todoDone == true).length;

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
      todayTotal++;
      result = true;
      waiting = false;
    }
    waiting = false;
    return result;
  }

  // ****************************** //
  // *        Delete Data         * //
  // ****************************** //

  Future<bool> deleteTodo(Todo delTodo) async {
    if (delTodo.todoDone == true) {
      todayDone--;
    }
    todayTotal--;
    _todos = _todos.where((todo) => todo.todoId != delTodo.todoId).toList();

    waiting = false; // 상태부터 변경합니다

    return await _repository
        .deleteTodo(delTodo.todoId.toString())
        .then((value) => value == true);
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
      if (todo.todoDate == getToday()) {
        todayDone += value ? -1 : 1;
      }

      // 달성하면 이벤트
      if (value == true) {
        EventService.publish(Event(
          type: EventType.onTodoDone,
          message: "할일을 달성했어요!",
        ));
      }
      waiting = false;
    }
  }

  // 개인 투두에 대한 완료 처리
  // 유저 상태정보를 업데이트
  Future<TodoCheckDto?> checkNormalTodo(int todoId, bool value) async {
    String todoIdStr = todoId.toString();
    TodoCheckDto? result = await _repository.checkNormalTodo(todoIdStr, value);
    return result;
  }

  Future<bool?> checkGroupTodo(int todoId, int userId, String path) async {
    bool? result = await _repository.checkGroupTodo(userId, todoId, path);
    return result;
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
