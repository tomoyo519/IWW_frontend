class GroupResult {
  // final GroupDetail grpDetail;
  final List<RouteDetail> routDetail;
  final List<GroupMember> grpMems;

  GroupResult({
    // required this.grpDetail,
    required this.routDetail,
    required this.grpMems,
  });

  factory GroupResult.fromJson(Map<String, dynamic> json) {
    var routDetailFromJson = json['rout_detail'] as List;
    List<RouteDetail> routDetailList =
        routDetailFromJson.map((i) => RouteDetail.fromJson(i)).toList();

    var grpMemsFromJson = json['grp_mems'] as List;
    List<GroupMember> grpMemsList =
        grpMemsFromJson.map((i) => GroupMember.fromJson(i)).toList();

    return GroupResult(
      // grpDetail: GroupDetail.fromJson(json['grp_detail']),
      routDetail: routDetailList,
      grpMems: grpMemsList,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      // 'grp_detail': grpDetail.toMap(),
      'rout_detail': routDetail.map((e) => e.toMap()).toList(),
      'grp_mems': grpMems.map((e) => e.toMap()).toList(),
    };
  }
}

class GroupDetail {
  final int grpId;
  final String grpName;
  final String grpDesc;
  final String regAt;
  final String userName;
  final String catName;
  final int? catId;

  GroupDetail({
    required this.grpId,
    required this.grpName,
    required this.grpDesc,
    required this.regAt,
    required this.userName,
    required this.catName,
    this.catId,
  });

  factory GroupDetail.fromJson(Map<String, dynamic> json) {
    return GroupDetail(
      grpId: json['grp_id'],
      grpName: json['grp_name'],
      grpDesc: json['grp_desc'],
      regAt: json['reg_at'],
      userName: json['user_name'] ?? 'user',
      catName: json['cat_name'],
      catId: json['cat_id'] ?? 0, // TODO: 수정
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grp_id': grpId,
      'grp_name': grpName,
      'grp_desc': grpDesc,
      'reg_at': regAt,
      'user_name': userName,
      'cat_name': catName,
    };
  }
}

class RouteDetail {
  final int routId;
  final String routName;
  final String routDesc;

  RouteDetail({
    required this.routId,
    required this.routName,
    required this.routDesc,
  });

  factory RouteDetail.fromJson(Map<String, dynamic> json) {
    return RouteDetail(
      routId: json['rout_id'],
      routName: json['rout_name'],
      routDesc: json['rout_desc'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'rout_id': routId,
      'rout_name': routName,
      'rout_desc': routDesc,
    };
  }
}

class GroupMember {
  final int userId;
  final String userName;
  final String lastLogin;

  GroupMember({
    required this.userId,
    required this.userName,
    required this.lastLogin,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['user_id'],
      userName: json['user_name'],
      lastLogin: json['last_login'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'last_login': lastLogin,
    };
  }
}
