import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/repository/group.repository.dart';

class LabelListModal extends StatelessWidget {
  final content;
  final Function(int) setLabel;

  Map<int, String>? catList;
  LabelListModal({
    super.key,
    required this.content,
    required this.setLabel,
  });

  static final List<String> labels = [
    '전체',
    '공부',
    '운동',
    '코딩',
    '게임',
    '명상',
    '학업',
    '독서',
    '여행',
    '약속',
    '집안일',
    '취미',
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
