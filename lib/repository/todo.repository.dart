import 'dart:convert';
import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';

class TodoRepository {
  final List<Todo> dummy = [
    Todo(
        todoId: 3,
        userId: 1,
        todoName: "miracle evening으로 변경되었다!!",
        todoDesc: "test",
        todoLabel: "2",
        todoDate: "2023-11-20T10:33:23.959Z",
        todoDone: true,
        todoStart: "2023-11-20T10:33:23.959Z",
        todoEnd: "2023-11-20T10:33:24.959Z",
        grpId: 1,
        todoImg: "",
        todoDeleted: false),
    Todo(
        todoId: 3,
        userId: 1,
        todoName: "2miracle evening으로 변경되었다!!2",
        todoDesc: "test",
        todoLabel: "2",
        todoDate: "2023-11-20T10:33:23.959Z",
        todoDone: true,
        todoStart: "2023-11-20T10:33:23.959Z",
        todoEnd: "2023-11-20T10:33:24.959Z",
        grpId: 1,
        todoImg: "",
        todoDeleted: false),
    Todo(
        todoId: 3,
        userId: 1,
        todoName: "3miracle evening으로 변경되었다!!3",
        todoDesc: "test",
        todoLabel: "2",
        todoDate: "2023-11-20T10:33:23.959Z",
        todoDone: true,
        todoStart: "2023-11-20T10:33:23.959Z",
        todoEnd: "2023-11-20T10:33:24.959Z",
        grpId: 1,
        todoImg: "",
        todoDeleted: false)
  ];

  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<Todo>?> getTodos(int? userId) async {
    // TODO - 서버 맛 간경우
    // return dummy;

    return await RemoteDataSource.get("/todo/user/${userId ?? 6}")
        .then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Todo.fromJson(data)).toList();
      }
      return null;
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.put("/todo/$id").then((response) {
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
