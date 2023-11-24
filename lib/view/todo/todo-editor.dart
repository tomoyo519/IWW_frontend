import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/custom-bottom-sheet-header.dart';
import 'package:iww_frontend/view/widget/todo/fields/date.dart';
import 'package:iww_frontend/view/widget/todo/fields/desc.dart';
import 'package:iww_frontend/view/widget/todo/fields/label.dart';
import 'package:iww_frontend/view/widget/todo/fields/name.dart';
import 'package:iww_frontend/view/widget/todo/fields/routine.dart';
import 'package:iww_frontend/view/widget/todo/fields/time.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

// bottom sheet 내용
class TodoEditorModal extends StatelessWidget {
  final Todo? todo;
  final String title;
  final GlobalKey<FormState> formKey;
  final TodoViewModel todoViewModel;

  const TodoEditorModal({
    Key? key,
    required this.todo,
    required this.title,
    required this.formKey,
    required this.todoViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 키보드에 따른 높이 조정
    // 키보드가 열려 있는지 확인
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    void onCancel(BuildContext context) {
      Navigator.pop(context);
      log("취소");
    }

    void onSave(BuildContext context) async {
      Navigator.pop(context);

      final viewModel = context.read<TodoEditorViewModel>();

      // 신규 생성
      if (viewModel.todoData['todo_id'] == null) {
        await viewModel.createTodo().then((result) {
          if (result == true && context.mounted) {
            Navigator.pop(context);

            // refresh data
            todoViewModel.fetchTodos();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('할일이 추가되었어요!'),
              ),
            );
          }
        });

        return;
      }

      // 수정
      await viewModel.updateTodo().then((result) {
        if (result == true && context.mounted) {
          Navigator.pop(context);

          // refresh data
          todoViewModel.fetchTodos();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('변경이 완료 되었어요!'),
            ),
          );
        }
      });
    }

    return FractionallySizedBox(
      heightFactor: isKeyboardOpen ? 0.9 : 0.58,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(children: [
          MyBottomSheetModalHeader(
            title: title,
            onSave: onSave,
            onCancel: onCancel,
          ),
          Expanded(
            // TODO: Custom 위젯 만들기
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MyColors.background,
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
                      children: const [
                        TodoNameField(),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              // horizontal: 10,
                              vertical: 15,
                            ),
                            child: Column(children: [
                              // 할일 상세내용 입력 필드
                              TodoDateField(),
                              TodoLabelField(),
                              TodoTimeField(),
                              TodoRoutineField(),
                              TodoDescField(),
                            ])),
                      ],
                    ),
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
