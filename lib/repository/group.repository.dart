import 'dart:convert';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/utils/logger.dart';

class GroupRepository {
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

  Future<List<Group>?> getAllGroupList(
      int? userId, int catId, String keyword) async {
    return await RemoteDataSource.get(
            "/group/search/${userId ?? 1}/${catId}/${keyword}")
        .then((res) {
      if (res.statusCode == 200) {
        LOG.log('thisisres/data: ${res.body}');
        var jsonData = jsonDecode(res.body);
        if (jsonData.isEmpty) {
          return null;
        }
        List<dynamic> results = jsonData["result"];
        List<Group> data = results
            .map((data) => Group.fromJson(data as Map<String, dynamic>))
            .toList()
            .cast<Group>();
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

  // TODO: create one은 routine 1개 생성과 연결
  // TODO: 상태를 상위 ViewModel로 전송하도록 수정 필요
  @override
  Future<bool> createTodo(Map<String, dynamic> data) async {
    var json = jsonEncode(data);
    return await RemoteDataSource.post("/group", body: json).then((res) {
      LOG.log(res.body);
      if (res.statusCode == 201) {
        return true;
      }
      return false;
    });
  }

  @override
  Future<bool> updateTodo(String id, Map<String, dynamic> data) async {
    // TODO: unimplemented.
    return true;
  }
}
