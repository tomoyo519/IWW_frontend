import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class CreateTodoDto extends ChangeNotifier {
  // todoId, todoDate, todoDone은 자동생성
  int userId;
  String todoName;

  // no todoImg, todoDeleted
  int? grpId;
  String? todoLabel;
  DateTime? todoDate;
  String? todoDesc;
  String? todoStart;
  String? todoEnd;

  CreateTodoDto.fromJson(Map<String, dynamic> json)
      : userId = json['user_id']!,
        todoName = json['todo_name'] {
    json.forEach((key, value) {
      if (value != null) {
        json[key] = value;
      }
    });
  }

  String toJson() => json.encode({
        'user_id': userId,
        "todo_name": todoName,
        "todo_desc": todoDesc,
        "todo_label": todoLabel,
        "todo_date": todoDate,
        "grp_id": grpId,
        "todo_start": todoStart,
        "todo_end": todoEnd,
      });
}
