import 'package:flutter/material.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class GroupTimeField extends StatelessWidget {
  const GroupTimeField({super.key});

  // 필드를 탭하면 실행
  _onTap(BuildContext context) async {
    // 현재 시간을 가져온다
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    // 타이머에 세팅
    if (selectedTime != null && context.mounted) {
      Provider.of<EditorModalViewModel>(
        context,
        listen: false,
      ).todoStart = selectedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _onTap(context),
        child: TodoFormFieldLayout(
            icon: Icons.access_alarm_rounded,
            child: Consumer<EditorModalViewModel>(
              builder: (context, viewModel, child) {
                String timeString = '${viewModel.hour}시 ${viewModel.min}분';
                return Text(timeString.toString());
              },
            )),
      ),
    );
  }
}
