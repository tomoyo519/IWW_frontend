import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/view/todo/layout/form-field.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoLabelField extends StatelessWidget {
  const TodoLabelField({
    super.key,
  });

  // 필드를 탭하면 실행
  _onTap(BuildContext context) {
    LOG.log("taptap");
    showModalBottomSheet(
        context: context,
        builder: (bottomSheetContext) {
          return LabelListModal(
            content: "label",
            setLabel: (int newLabel) {
              Provider.of<TodoEditorViewModel>(
                context,
                listen: false,
              ).todoLabel = newLabel;
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: TodoFormFieldLayout(
          icon: Icons.label_important_outline,
          child: Consumer<TodoEditorViewModel>(
            builder: (context, viewModel, child) {
              return Text((viewModel.todoData['todo_label'] != null)
                  ? LabelListModal.labels[(viewModel.todoData['todo_label'])]
                  : LabelListModal.labels[0]);
            },
          )),
    );
  }
}
