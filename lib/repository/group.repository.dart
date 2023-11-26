import 'dart:convert';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
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

  Future<List<GroupDetail>?> getGroupDetail(int? groupId) async {
    return await RemoteDataSource.get("/group/${groupId ?? 1}").then((res) {
      if (res.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(res.body);

        if (jsonData.isEmpty) {
          return null;
        }

        List<GroupDetail>? data = // 수정된 부분
            jsonData.map((data) => GroupDetail.fromJson(data)).toList();
        LOG.log('data: $data');
        return data;
      }
      return null;
    });
  }
}
