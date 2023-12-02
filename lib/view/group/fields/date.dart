import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/view/todo/calendar.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class GroupDateField extends StatelessWidget {
  const GroupDateField({
    super.key,
  });

  // 필드를 탭하면 실행
  _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return Calendar(setSelectedDay: (newDate) {
          Provider.of<EditorModalViewModel>(
            context,
            listen: false,
          ).todoDate = newDate.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: TodoFormFieldLayout(
        icon: Icons.calendar_month_rounded,
        child: Consumer<EditorModalViewModel>(
          builder: (context, viewModel, child) {
            final format = DateFormat('yyyy년 M월 d일');
            final dateTimeString = DateTime.now().toString();
            final dateTime = DateTime.parse(
              viewModel.todoData['todo_date'] ?? dateTimeString,
            );
            return Text(format.format(dateTime));
          },
        ),
      ),
    );
  }
}
