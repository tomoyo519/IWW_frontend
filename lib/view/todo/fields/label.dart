import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/categories.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
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
              Provider.of<EditorModalViewModel>(
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
          child: Consumer<EditorModalViewModel>(
            builder: (context, viewModel, child) {
              return Text((viewModel.todoData['todo_label'] != null)
                  ? TodoCategory
                      .category![(viewModel.todoData['todo_label'])].name
                  : TodoCategory.category![0].name);
            },
          )),
    );
  }
}
