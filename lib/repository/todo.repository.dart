import 'dart:convert';
import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';

class TodoRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<Todo>?> getTodos(int? userId) async {
    // TODO - 서버 맛 간경우
    // return dummy;
    print('getTodos 실해');
    return await RemoteDataSource.get("/todo/user/${userId ?? 1}")
        .then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Todo>? data = jsonData.map((data) => Todo.fromJson(data)).toList();

        // 일주일 전인 경우 필터링
        DateTime weekAgo = DateTime.now().subtract(Duration(days: 7));
        data = data
            .where((element) => DateTime.parse(
                  element.todoDate,
                ).isAfter(weekAgo))
            .toList();

        // 정렬해서 넘김
        data.sort((a, b) => a.todoDate.compareTo(b.todoDate));

        return data;
      }
      return null;
    });
  }

  /// ================== ///
  ///       Create       ///
  /// ================== ///
  Future<bool> createTodo(Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post(
      "/todo",
      body: json,
    ).then((response) {
      log("Create Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.put(
      "/todo/$id",
      body: json,
    ).then((response) {
      log("Update Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Patch       ///
  /// ================== ///

  Future<bool> checkTodo(String id, bool checked, String path) async {
    return await RemoteDataSource.patch(
      "/todo/$id",
      body: {"todo_done": checked},
    ).then((response) {
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // if (path.isNotEmpty) {
        //   // TODO - 사진 전송 연결
        //   //  RemoteDataSource.patch("/group/$id/user/$user_id/image")
        // }
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Delete       ///
  /// ================== ///
  Future<bool> deleteTodo(String id) async {
    return await RemoteDataSource.delete(
      "/todo/$id",
    ).then((response) {
      log("Delete Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
