import 'dart:convert';

import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';

///** 할일 완료 응답 객체
/// * https://www.notion.so/todo-todo_id-af279481eb8e44a88a77da2a4d720a3e?pvs=4
/// *
/// {
//     "result": {
//         "user_id": 29,
//         "user_cash": 100380,
//         "todo_id": 150,
//         "todo_done": false,
//         "item_id": 54,
//         "pet_exp": 75
//     }
// }
/// */
class TodoUpdateDto {
  final int userId;
  final int userCash;
  final int todoId;
  final bool todoDone;
  final int itemId;
  final int petExp;

  // final Todo todo;
  // final UserModel user;

  TodoUpdateDto({
    required this.userId,
    required this.userCash,
    required this.todoId,
    required this.todoDone,
    required this.itemId,
    required this.petExp,
  });

  factory TodoUpdateDto.fromJson(String data) {
    var jsonData = jsonDecode(data);
    return TodoUpdateDto(
      userId: jsonData['user_id'],
      userCash: jsonData['user_cash'],
      todoId: jsonData['todo_id'],
      todoDone: jsonData['todo_done'],
      itemId: jsonData['item_id'],
      petExp: jsonData['pet_exp'],
    );
  }
}
