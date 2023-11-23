import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/custom-bottom-sheet-header.dart';
import 'package:iww_frontend/view/widget/home.dart';

class LabelListModal extends StatelessWidget {
  final content;
  final Function(int) setLabel;

  LabelListModal({
    super.key,
    required this.content,
    required this.setLabel,
  });

  static final List<String> labels = [
    '🏫 공부/학업',
    '🍎 다이어트',
    '👊 운동/건강',
    '📕 자기계발',
    '🏝️ 취미/여행',
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
        MyBottomSheetModalHeader(
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
