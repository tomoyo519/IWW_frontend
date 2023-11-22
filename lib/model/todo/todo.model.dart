import "dart:convert";
import "package:http/http.dart" as http;

class Todo {
  int? todoId;
  int userId;
  String todoName;
  String? todoDesc;
  String? todoLabel;
  DateTime? todoDate;
  bool? todoDone;
  String? todoStart;
  String? todoEnd;
  String? todoImg;
  String? grpId;
  String? todoDeleted;

  Todo(
      {this.todoId,
      required this.userId,
      required this.todoName,
      this.todoDesc,
      this.todoLabel,
      this.todoDate,
      this.todoDone,
      this.todoStart,
      this.todoEnd,
      this.todoImg,
      this.grpId,
      this.todoDeleted});

  bool get isDone => todoDone ?? false;

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
}
