import 'dart:convert';

import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';

class TodoUpdateDto {
  final Todo todo;
  final UserModel user;

  TodoUpdateDto({
    required this.todo,
    required this.user,
  });

  factory TodoUpdateDto.fromJson(String data) {
    var jsonData = jsonDecode(data);
    UserModel user = UserModel.fromJson(jsonData['updated_user']);
    Todo todo = Todo.fromJson(jsonData['updated_todo']);
    return TodoUpdateDto(
      todo: todo,
      user: user,
    );
  }
}
