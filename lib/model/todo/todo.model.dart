import "dart:convert";

import "package:http/http.dart" as http;
import "package:intl/intl.dart";

class Todo {
  int todoId;
  int userId;
  String todoName;
  String? todoDesc;

  int? todoLabel;

  String todoDate;
  bool todoDone;
  String todoStart;
  String todoEnd;
  String? todoImg;
  int? grpId;
  bool todoDeleted;

  Todo({
    required this.todoId,
    required this.userId,
    required this.todoName,
    this.todoDesc,
    int? todoLabel,
    String? todoDate,
    bool? todoDone,
    String? todoStart,
    String? todoEnd,
    this.todoImg,
    this.grpId,
    bool? todoDeleted,
  })  : todoDate = todoDate ?? defaultDate(),
        todoDone = todoDone ?? false,
        todoLabel = todoLabel ?? 0,
        todoStart = todoStart ?? "00:00",
        todoEnd = todoEnd ?? "00:00",
        todoDeleted = todoDeleted ?? false;

  bool get isDone => todoDone;

  static defaultDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'todo_id': todoId,
      'user_id': userId,
      'todo_name': todoName,
      'todo_desc': todoDesc,
      'todo_label': todoLabel,
      'todo_date': todoDate,
      'todo_done': todoDone,
      'todo_start': todoStart,
      'todo_end': todoEnd,
      'todo_img': todoImg,
      'grp_id': grpId,
      'todo_deleted': todoDeleted,
    };
  }

  Future<bool> setDone(bool value) async {
    todoDone = value;
    var result = await http
        .patch(
      Uri.parse('http://yousayrun.store:8088/todo/$todoId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'todo_done': value}),
    )
        .catchError((e) {
      print(e);
      throw e('setDone error');
    });

    return result.statusCode == 200;
  }

  static Future<bool> requestCreate(Map<String, dynamic> json) async {
    return await http
        .post(
      Uri.parse('http://yousayrun.store:8088/todo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json),
    )
        .then((response) {
      if (response.statusCode == 201) {
        return true;
      } else {
        print("response.statusCode: ${response.statusCode}");
        throw Exception('Failed to create todo');
      }
    });
  }

  factory Todo.fromJson(Map<String, dynamic> body) {
    String date = body['todo_date'];
    date = date.replaceAll('-', '');
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);

    return Todo(
      todoId: body['todo_id'],
      userId: body['user_id'],
      todoName: body['todo_name'],
      todoDesc: body['todo_desc'],
      todoLabel: body['todo_label'],
      todoDate: '$year-$month-$day',
      todoDone: body['todo_done'],
      todoStart: body['todo_start'],
      todoEnd: body['todo_end'],
      grpId: body['grp_id'],
      todoImg: body['todo_img'],
      todoDeleted: body['todo_deleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todo_id': todoId,
      'user_id': userId,
      'todo_name': todoName,
      'todo_desc': todoDesc,
      'todo_label': todoLabel,
      'todo_date': todoDate,
      'todo_done': todoDone,
      'todo_start': todoStart,
      'todo_end': todoEnd,
      'todo_img': todoImg,
      'grp_id': grpId,
      'todo_deleted': todoDeleted,
    };
  }
}
