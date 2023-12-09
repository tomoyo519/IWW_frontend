import 'package:flutter/material.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoRoutineField extends StatelessWidget {
  const TodoRoutineField({
    super.key,
  });

  _onTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bottomSheetContext) {
          return LabelListModal(
            content: "routine",
            setLabel: (int newLabel) {
              Provider.of<EditorModalViewModel>(
                context,
                listen: false,
              ).todoRoutine = LabelListModal.routines[newLabel];
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: TodoFormFieldLayout(
          icon: Icons.star_border_rounded,
          child: Consumer<EditorModalViewModel>(
            builder: (context, viewModel, child) =>
                Text(viewModel.todoRoutine ?? LabelListModal.routines[0]),
          )),
    );
  }
}
