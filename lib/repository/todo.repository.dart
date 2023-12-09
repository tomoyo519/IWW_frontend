import 'dart:io';
import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/utils/logger.dart';

class TodoRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<Map<String, List<Todo>>> getTodos(int userId) async {
    return await RemoteDataSource.get("/todo/user/$userId").then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // 만약 할일이 없으면
        if (jsonData.isEmpty) {
          return {
            "normal": [],
            "group": [],
            "total": [],
          };
        }

        List<Todo>? data = jsonData.map((data) => Todo.fromJson(data)).toList();
        // 오늘
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        List<Todo> normal = data
            .where((e) => (e.grpId == null &&
                (DateTime.parse(e.todoDate).isAfter(yesterday) ||
                    e.todoDone == false)))
            .toList();

        List<Todo> group = data
            .where((e) => (e.grpId != null &&
                DateTime.parse(e.todoDate).isAfter(yesterday)))
            .toList();

        return {
          "normal": normal,
          "group": group,
          "total": data,
        };
      }
      return {
        "normal": [],
        "group": [],
        "total": [],
      };
    });
  }

  Future<Todo?> getTodoDetail(int todoId) async {
    return await RemoteDataSource.get('/todo/$todoId').then((response) {
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        return Todo.fromJson(jsonBody['result']);
      }
      return null;
    });
  }

  /// ================== ///
  ///       Create       ///
  /// ================== ///
  Future<Todo?> createTodo(Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post(
      "/todo",
      body: json,
    ).then((response) {
      if (response.statusCode == 201) {
        var jsonBody = jsonDecode(response.body);

        LOG.log("Todo created: ${response.statusCode}, ${response.body}");
        return Todo.fromJson(jsonBody);
      }
      return null;
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  Future<Todo?> updateTodo(String id, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.put(
      "/todo/$id",
      body: json,
    ).then((response) {
      if (response.statusCode == 200) {
        LOG.log("Update Todo: ${response.statusCode}, ${response.body}");
        var jsonBody = jsonDecode(response.body);
        return Todo.fromJson(jsonBody);
      }
      return null;
    });
  }

  /// ================== ///
  ///       Patch        ///
  /// ================== ///
  Future<TodoCheckDto?> checkNormalTodo(String id, bool checked) async {
    return await RemoteDataSource.patch(
      "/todo/$id",
      body: {"todo_done": checked},
    ).then((response) {
      LOG.log("${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        return TodoCheckDto.fromJson(jsonBody['result']);
      }
      return null;
    });
  }

  // 그룹 할일 인증
  Future<bool> checkGroupTodo(int userId, int todoId, String path) async {
    var image = File(path);
    return await RemoteDataSource.patchFormData(
            "/group/$todoId/user/$userId/image", 'file',
            file: image, filename: path)
        .then((res) {
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    }).catchError((err) {
      LOG.log('Error sending image');
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
      LOG.log("Delete Todo: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Confirm      ///
  /// ================== ///
  Future<bool> confirmGroupTodo(String id) async {
    return await RemoteDataSource.patch(
      "/group/user/$id/approve",
    ).then((response) {
      LOG.log("confirmGroupTodo: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
