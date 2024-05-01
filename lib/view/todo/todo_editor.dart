import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/todo/fields/desc.dart';
import 'package:iww_frontend/view/todo/fields/label.dart';
import 'package:iww_frontend/view/todo/fields/name.dart';
import 'package:iww_frontend/view/todo/fields/routine.dart';
import 'package:iww_frontend/view/todo/fields/time.dart';

// bottom sheet 내용
class EditorModal extends StatelessWidget {
  final String title;
  final Todo? init;
  final Function(BuildContext) onSave;
  final Function(BuildContext) onCancel;
  TextEditingController? controller;
  FocusNode? focusNode;

  EditorModal({
    Key? key,
    required this.init,
    required this.title,
    required this.onSave,
    required this.onCancel,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 키보드에 따른 높이 조정 키보드가 열려 있는지 확인
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: isKeyboardOpen ? 0.96 : 0.5,
        child: GestureDetector(
          // onTap: () => FocusScope.of(context).unfocus(),
          onTap: () => (),
          child: Column(
            children: [
              BottomSheetModalHeader(
                title: title,
                onSave: onSave,
                onCancel: onCancel,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 할일 제목 입력 필드
                        children: [
                          TodoNameField(
                            focusNode: focusNode,
                            controller: controller,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              // horizontal: 10,
                              vertical: 15,
                            ),
                            child: Column(
                              children: [
                                // 할일 상세내용 입력 필드
                                // TodoDateField(),
                                if (title != "루틴 추가") TodoLabelField(),
                                TodoTimeField(),
                                TodoRoutineField(),
                                TodoDescField(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
