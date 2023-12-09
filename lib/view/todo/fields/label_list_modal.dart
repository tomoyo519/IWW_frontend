import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';

class GroupCategory {
  final int catId;
  final String catName;
  final String catImg;

  GroupCategory({
    required this.catId,
    required this.catName,
    required this.catImg,
  });

  factory GroupCategory.fromJson(Map<String, dynamic> data) {
    return GroupCategory(
      catId: data['cat_id'],
      catName: data['cat_name'],
      catImg: data['cat_img'],
    );
  }
}

class LabelListModal extends StatefulWidget {
  final content;
  final Function(int) setLabel;

  LabelListModal({
    super.key,
    required this.content,
    required this.setLabel,
  });

  static final List<String> labels = [
    "전체",
    "요가",
    "공부",
    "운동",
    "코딩",
    "게임",
    "명상",
    "모임",
    "학업",
    "자유시간",
    "자기관리",
    "독서",
    "여행",
    "유튜브",
    "약속",
    "산책",
    "집안일",
    "취미",
    "기타",
  ];

  static final List<String> routines = [
    '매일',
    '평일',
    '주말',
    '매주',
  ];

  @override
  State<LabelListModal> createState() => _LabelListModalState();
}

class _LabelListModalState extends State<LabelListModal> {
  List<GroupCategory>? categories;
  bool isLoading = true;

  @override
  void initState() async {
    super.initState();

    await RemoteDataSource.get('/category').then((res) {
      if (res.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(res.body);
        categories = jsonList.map((e) => GroupCategory.fromJson(e)).toList();
        isLoading = false;
      }
    });
  }

  // static final List<String> labels = [
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetModalHeader(
          title: "라벨 선택",
        ),
        Expanded(
          child: !isLoading && categories != null
              ? ListView.builder(
                  itemCount: categories!.length,
                  itemBuilder: (c, i) {
                    return TextButton(
                        onPressed: () {
                          widget.setLabel(i);
                          Navigator.pop(context);
                        },
                        child: Text(categories![i].catName));
                  })
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
