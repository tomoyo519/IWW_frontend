import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

class GroupLabelField extends StatelessWidget {
  const GroupLabelField({
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
              Provider.of<MyGroupViewModel>(
                context,
                listen: false,
              ).groupCat = newLabel;
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
          child: Consumer<MyGroupViewModel>(
            builder: (context, viewModel, child) {
              return Text((viewModel.groupData['cat_id'] != null)
                  ? LabelListModal.labels[(viewModel.groupData['cat_id'])]
                  : LabelListModal.labels[0]);
            },
          )),
    );
  }
}
