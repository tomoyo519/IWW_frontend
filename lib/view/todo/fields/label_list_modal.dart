import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';

class LabelListModal extends StatelessWidget {
  final content;
  final Function(int) setLabel;

  LabelListModal({
    super.key,
    required this.content,
    required this.setLabel,
  });

  static final List<String> labels = [
    "전체", //1
    "공부", //2
    "운동", //3
    "코딩", //4
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
    "기타", // 18
  ];

  static final List<String> routines = [
    '매일',
    '평일',
    '주말',
    '매주',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetModalHeader(
          title: "라벨 선택",
        ),
        Expanded(
          child: ListView.builder(
              itemCount: content == "label" ? labels.length : routines.length,
              itemBuilder: (c, i) {
                return TextButton(
                    onPressed: () {
                      setLabel(i);
                      Navigator.pop(context);
                    },
                    child: content == "label"
                        ? Text(labels[i])
                        : Text(routines[i]));
              }),
        ),
      ],
    );
  }
}
