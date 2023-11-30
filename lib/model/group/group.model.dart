class Group {
  int groupId;
  String grpName;
  String? grpDesc;
  int? catId;
  String? catName;
  String ownerName;
  String memCnt;

  Group({
    required this.groupId,
    required this.grpName,
    required this.ownerName,
    required this.memCnt,
    this.grpDesc,
    this.catName,
    this.catId,
  });

  factory Group.fromJson(Map<String, dynamic> body) {
    return Group(
      groupId: body['grp_id'],
      grpName: body['grp_name'],
      grpDesc: body['grp_decs'],
      catId: body['cat_id'],
      catName: body['cat_name'],
      ownerName: body['owner'],
      memCnt: body['mem_cnt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grp_id': groupId,
      'grp_name': grpName,
      'grp_decs': grpDesc,
      'cat_id': catId,
      'cat_name': catName,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'grp_name': grpName,
      'grp_decs': grpDesc,
      'cat_id': catId,
      'cat_name': catName,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }
}
