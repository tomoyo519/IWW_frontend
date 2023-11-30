import 'package:flutter/material.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/view/todo/layout/form-field.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

class GroupRoutineField extends StatelessWidget {
  const GroupRoutineField({
    super.key,
  });

  _onTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bottomSheetContext) {
          return LabelListModal(
            content: "routine",
            setLabel: (int newLabel) {
              Provider.of<MyGroupViewModel>(
                context,
                listen: false,
              ).groupRoutine = LabelListModal.routines[newLabel];
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
          child: Consumer<MyGroupViewModel>(
            builder: (context, viewModel, child) =>
                Text(viewModel.groupRoutine ?? LabelListModal.routines[0]),
          )),
    );
  }
}
