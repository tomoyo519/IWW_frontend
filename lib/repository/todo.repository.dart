import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class TodoRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<Todo>?> getTodos(int? userId) async {
    print(userId);
    return await RemoteDataSource.get("/todo/user/${userId ?? 1}")
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
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

  Future<bool> checkTodo(
      String userId, String id, bool checked, String path) async {
    print('path:$path');
    return await RemoteDataSource.patch(
      "/todo/$id",
      body: {"todo_done": checked},
    ).then((response) async {
      if (response.statusCode == 200) {
        print('response.body : ${response.body}');
        if (path.isNotEmpty) {
          // TODO - 사진 전송 연결
          var image = File(path);
          var result = await RemoteDataSource.patchFormData(
                  "/group/$id/user/$userId/image", 'file',
                  file: image, filename: path)
              .then((res) {
            print('res.statusCode: ${res.statusCode}');
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
    print('삭제 실행');
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
