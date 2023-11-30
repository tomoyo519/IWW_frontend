import 'dart:io';
import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/utils/logger.dart';

class TodoRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<Todo>> getTodos(int? userId) async {
    // var rtn = await DummyData.todoDummy();
    // LOG.log("$rtn");
    // return rtn;
    return await RemoteDataSource.get("/todo/user/${userId ?? 1}")
        .then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // 만약 할일이 없으면
        if (jsonData.isEmpty) {
          return [];
        }

        List<Todo>? data = jsonData.map((data) => Todo.fromJson(data)).toList();
        // 오늘
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        data = data
            .where((element) =>
                DateTime.parse(
                  element.todoDate,
                ).isAfter(yesterday) ||
                element.todoDone == false)
            .toList();

        // 정렬해서 넘김
        data.sort((a, b) => a.todoDate.compareTo(b.todoDate));
        return data;
      }
      return [];
    });
  }

  /// ================== ///
  ///       Create       ///
  /// ================== ///
  @override
  Future<bool> createTodo(Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post(
      "/todo",
      body: json,
    ).then((response) {
      if (response.statusCode == 201) {
        LOG.log("Todo created: ${response.statusCode}, ${response.body}");
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  @override
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.put(
      "/todo/$id",
      body: json,
    ).then((response) {
      LOG.log("Update Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  /// ================== ///
  ///       Patch       ///
  /// ================== ///
  Future<bool> checkNormalTodo(String id, bool checked) async {
    return await RemoteDataSource.patch(
      "/todo/$id",
      body: {"todo_done": checked},
    ).then((response) {
      LOG.log("Check Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  // 그룹 할일 체크
  Future<bool> checkGroupTodo(
      String userId, String id, bool checked, String path) async {
    return await RemoteDataSource.patch(
      "/todo/$id",
      body: {"todo_done": checked},
    ).then((response) async {
      if (response.statusCode == 200) {
        if (path.isNotEmpty) {
          // TODO - 사진 전송 연결
          var image = File(path);
          var result = await RemoteDataSource.patchFormData(
                  "/group/$id/user/$userId/image", 'file',
                  file: image, filename: path)
              .then((res) {
            if (res.statusCode == 200) {
              return true;
            }
            return false;
          }).catchError((err) {
            return false;
          }).catchError((err) {
            return false;
          });
        }
      }
      return true;
    });
  }

  /// ================== ///
  ///       Delete       ///
  /// ================== ///
  Future<bool> deleteTodo(String id) async {
    return await RemoteDataSource.delete(
      "/todo/$id",
    ).then((response) {
      LOG.log("Delete Todo: ${response.statusCode}, ${response.body}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
