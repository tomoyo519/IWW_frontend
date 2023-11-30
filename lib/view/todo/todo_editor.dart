import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/todo/fields/date.dart';
import 'package:iww_frontend/view/todo/fields/desc.dart';
import 'package:iww_frontend/view/todo/fields/label.dart';
import 'package:iww_frontend/view/todo/fields/name.dart';
import 'package:iww_frontend/view/todo/fields/routine.dart';
import 'package:iww_frontend/view/todo/fields/time.dart';

// bottom sheet 내용
class EditorModal extends StatelessWidget {
  final String title;
  final Todo? init;
  final GlobalKey<FormState> formKey;
  final Function(BuildContext) onSave;
  final Function(BuildContext) onCancel;

  const EditorModal({
    Key? key,
    required this.init,
    required this.title,
    required this.formKey,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 키보드에 따른 높이 조정 키보드가 열려 있는지 확인
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return FractionallySizedBox(
      heightFactor: isKeyboardOpen ? 0.9 : 0.58,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            BottomSheetModalHeader(
              title: title,
              onSave: onSave,
              onCancel: onCancel,
            ),
            Expanded(
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 할일 제목 입력 필드
                        children: [
                          TodoNameField(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              // horizontal: 10,
                              vertical: 15,
                            ),
                            child: Column(
                              children: [
                                // 할일 상세내용 입력 필드
                                TodoDateField(),
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
            )
          ],
        ),
      ),
    );
  }
}
