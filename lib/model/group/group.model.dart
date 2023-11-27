class Group {
  int groupId;
  String grpName;
  String ownerName;
  int memCnt;

  Group({
    required this.groupId,
    required this.grpName,
    required this.ownerName,
    required this.memCnt,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'grp_name': grpName,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'grp_name': grpName,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['group_id'],
      grpName: json['grp_name'],
      ownerName: json['owner'],
      memCnt: json['mem_cnt'],
    );
  }
}
