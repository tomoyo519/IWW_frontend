import 'dart:convert';

import 'package:flutter/material.dart';
import '/model/todo/todo.model.dart';
import '/model/routine/routine.model.dart';

class GenerateTodo {
  final int userId;
  final List<Map<String, dynamic>> routines;

  GenerateTodo({
    required this.userId,
    required this.routines,
  });

  Future<void> generateTodoFromRoutines() async {
    for (final json in routines) {
      final Routine routine = Routine(
        routName: json['rout_name'],
        routDesc: json['rout_desc'],
        routRepeat: json['rout_repeat'],
        grpId: json['grp_id'],
        routId: json['rout_id'],
        routSrt: json['rout_srt'],
        routEnd: json['rout_end'],
      );

      final todo = routine.generateTodo(userId);
      print(todo.toJson());
      print(jsonEncode(todo.toJson()));

      // Todo 클래스에서 requestCreate가 비동기로 동작하며, 이에 맞게 await를 사용합니다.
      await Todo.requestCreate(todo.toJson());
    }
  }
}
