import 'package:flutter/material.dart';

class LabelList extends StatelessWidget {
  LabelList({this.content, required this.setLabel, super.key});
  var content;
  Function(int) setLabel;
  final List<String> labels = [
    '운동',
    '식단',
    '회사업무',
    '가족행사',
    '저녁약속',
    '청첩장모임',
    '루틴',
    '개발공부'
  ];

  final List<String> routines = ['매일', '평일', '주말', '매주'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
