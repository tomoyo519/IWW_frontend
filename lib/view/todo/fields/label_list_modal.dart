import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/categories.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';

class LabelListModal extends StatefulWidget {
  final content;
  final Function(int) setLabel;
  // List<Category>? category;

  LabelListModal({
    super.key,
    required this.content,
    required this.setLabel,
  });

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
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    TodoCategory.initialize().then((value) {
      setState(() {
        waiting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LOG.log(TodoCategory.category![0].name);
    return waiting // 로딩중
        ? SizedBox.shrink()
        : Column(
            children: [
              BottomSheetModalHeader(
                title: "라벨 선택",
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.content == "label"
                        ? TodoCategory.category!.length
                        : LabelListModal.routines.length,
                    itemBuilder: (c, i) {
                      return TextButton(
                          onPressed: () {
                            widget.setLabel(i);
                            Navigator.pop(context);
                          },
                          child: widget.content == "label"
                              ? Text(TodoCategory.category![i].name)
                              : Text(LabelListModal.routines[i]));
                    }),
              ),
            ],
          );
  }
}
