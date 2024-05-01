import 'dart:convert';

import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/utils/logger.dart';

///** 할일 완료 응답 객체
/// */
class TodoCheckDto {
  final int userId;
  final int userCash;
  final int todoId;
  final bool todoDone;

  // 그룹 투두 체크에만 있는 필드
  int? itemId;
  int? petExp;

  TodoCheckDto({
    required this.userId,
    required this.userCash,
    required this.todoId,
    required this.todoDone,
    this.itemId,
    this.petExp,
  });

  factory TodoCheckDto.fromJson(Map<String, dynamic> data) {
    LOG.log(data.toString());
    return TodoCheckDto(
      userId: data['user_id'],
      userCash: data['user_cash'],
      todoId: data['todo_id'],
      todoDone: data['todo_done'],
      itemId: data['item_id'],
      petExp: data['pet_exp'],
    );
  }
}
