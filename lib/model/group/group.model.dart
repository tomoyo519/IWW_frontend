import 'dart:convert';

import 'package:iww_frontend/utils/logger.dart';

class Group {
  int groupId;
  String grpName;
  String? grpDesc;
  int? catId;
  String? catImg;
  String? catName;
  String? ownerName;
  String memCnt;

  Group({
    required this.groupId,
    required this.grpName,
    this.ownerName,
    required this.memCnt,
    this.grpDesc,
    this.catName,
    this.catImg,
    this.catId,
  });

  factory Group.fromJson(Map<String, dynamic> body) {
    LOG.log(jsonEncode(body));
    return Group(
      groupId: body['grp_id'],
      grpName: body['grp_name'],
      grpDesc: body['grp_desc'],
      catId: body['cat_id'],
      catName: body['cat_name'],
      catImg: body['cat_img'],
      ownerName: body['owner'],
      memCnt: body['mem_cnt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grp_id': groupId,
      'grp_name': grpName,
      'grp_desc': grpDesc,
      'cat_id': catId,
      'cat_name': catName,
      'cat_img': catImg,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'grp_name': grpName,
      'grp_desc': grpDesc,
      'cat_id': catId,
      'cat_name': catName,
      'cat_img': catImg,
      'owner': ownerName,
      'mem_cnt': memCnt
    };
  }
}
