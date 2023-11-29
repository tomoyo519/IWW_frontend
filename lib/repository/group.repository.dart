import 'dart:convert';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/repository/base_todo.repository.dart';

class GroupRepository implements BaseTodoRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<Group>?> getMyGroupList(int? userId) async {
    return await RemoteDataSource.get("/group/${userId ?? 1}/groups")
        .then((res) {
      if (res.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(res.body);

        if (jsonData.isEmpty) {
          return null;
        }

        List<Group>? data = // 수정된 부분
            jsonData.map((data) => Group.fromJson(data)).toList();
        print(data);
        return data;
      }
      return null;
    });
  }

  Future<GroupDetail?> getGroupDetail(int? groupId) async {
    return await RemoteDataSource.get("/group/${groupId ?? 1}").then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);
        if (jsonData.isEmpty) {
          return null;
        }

        return jsonData;
      }
      return null;
    });
  }

  Future<List<RouteDetail>?> getRouteDetail(int? groupId) async {
    return await RemoteDataSource.get("/group/${groupId ?? 1}").then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        if (jsonData.isEmpty) {
          return null;
        }

        List<RouteDetail>? data = // 수정된 부분
            jsonData["rout_detail"]
                .map((data) => GroupDetail.fromJson(data))
                .toList();

        return data;
      }
      return null;
    });
  }

  Future<List<GroupMember>?> getMember(int? groupId) async {
    return await RemoteDataSource.get("/group/${groupId ?? 1}").then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        if (jsonData.isEmpty) {
          return null;
        }

        List<GroupMember>? data = // 수정된 부분
            jsonData["grp_mems"]
                .map((data) => GroupDetail.fromJson(data))
                .toList();

        return data;
      }
      return null;
    });
  }

  @override
  Future<bool> createOne(Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post("/group", body: json).then((res) {
      if (res.statusCode == 201) {
        return true;
      }
      return false;
    });
  }

  @override
  Future<bool> updateOne(String id, Map<String, dynamic> data) async {
    // TODO: unimplemented.
    return true;
  }
}
