import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/Group/group.model.dart';

class GroupRepository {
  /// ================== ///
  ///         Get        ///
  /// ================== ///
  Future<List<dynamic>?> getMyGroupList(int? userId) async {
    return await RemoteDataSource.get("/group/${userId ?? 1}/groups")
        .then((res) {
      if (res.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(res.body);

        if (jsonData.isEmpty) {
          return null;
        }

        List<Group>? data =
            jsonData.map((data) => Group.fromJson(data)).toList();
        return jsonData;
      }
    });
  }
}
