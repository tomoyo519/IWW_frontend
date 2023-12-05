// 투두 에디팅 화면의 상태를 관리
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';

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
  final Map<String, dynamic> _todoData;
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

  // ****************************** //
  // *        Validate Data       * //
  // ****************************** //

  // 'todo_id': todoId,
  //     'user_id': userId,
  //     'todo_name': todoName, //
  //     'todo_desc': todoDesc, //
  //     'todo_label': todoLabel, //
  //     'todo_date': todoDate, //
  //     'todo_done': todoDone, //
  //     'todo_start': todoStart,
  //     'todo_end': todoEnd,
  //     'todo_img': todoImg,
  //     'grp_id': grpId,
  //     'todo_deleted': todoDeleted,
  // bool validate() {
  // return _todoData['todo_name']
  // }

  // ****************************** //
  // *        Create Data         * //
  // ****************************** //
  // 상위 ViewModel (TodoViewModel & GroupViewModel)
  // createTodo 함수를 부릅니다
  Future<bool> createTodo() async {
    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    todoData['user_id'] = user.userId;
    todoData['todo_start'] = timeString;

    // 상위 뷰모델의 함수를 불러
    return await parent.createTodo(todoData);
  }

  // ****************************** //
  // *        Create Data         * //
  // ****************************** //
  // 상위 ViewModel (TodoViewModel & GroupViewModel)
  // updateTodo 함수를 부릅니다
  Future<bool> updateTodo() async {
    var id = todoData["todo_id"];

    String timeString =
        '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00';

    todoData['todo_start'] = timeString;
    return await parent.updateTodo(id.toString(), todoData);
  }
}
