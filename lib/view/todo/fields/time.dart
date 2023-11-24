import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/label-list-modal.dart';
import 'package:iww_frontend/view/widget/todo/layout/form-field.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

//                     Row(
//                       children: [
//                         Container(
//                             padding: EdgeInsets.all(10),
//                             child: GestureDetector(
//                                 onTap: () async {
//                                   final TimeOfDay? selectedTime =
//                                       await showTimePicker(
//                                     initialTime: TimeOfDay.now(),
//                                     context: context,
//                                   );

//                                   if (selectedTime != null &&
//                                       context.mounted) {
//                                     Provider.of<TodoViewModel>(
//                                       context,
//                                       listen: false,
//                                     ).setSelectedAlarmTime(
//                                         selectedTime);
//                                   }
//                                 },
//                                 child: TodoFormFieldLayout(
//                                   icon: Icons.access_alarm_rounded,
//                                   child: Consumer<TodoViewModel>(
//                                     builder:
//                                         (context, selectedDate, child) {
//                                       String timeString =
//                                           '${selectedDate.selectedAlarmTime.hour}시 ${selectedDate.selectedAlarmTime.minute}분';
//                                       return Text(
//                                           timeString.toString());
//                                     },
//                                   ),
//                                 ))),
//                       ],
//                     ),

class TodoTimeField extends StatelessWidget {
  const TodoTimeField({super.key});

  // 필드를 탭하면 실행
  _onTap(BuildContext context) async {
    // 현재 시간을 가져온다
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    // 타이머에 세팅
    if (selectedTime != null && context.mounted) {
      Provider.of<TodoEditorViewModel>(
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
            child: Consumer<TodoEditorViewModel>(
              builder: (context, viewModel, child) {
                String timeString = '${viewModel.hour}시 ${viewModel.min}분';
                return Text(timeString.toString());
              },
            )),
      ),
    );
  }
}
