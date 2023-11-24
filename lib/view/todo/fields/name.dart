import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

// 할일 제목 필드
class TodoNameField extends StatelessWidget {
  const TodoNameField({
    super.key,
    // required this.todo,
    // required this.viewModel,
  });

  // final Todo todo;
  // final TodoEditorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TodoEditorViewModel>();
    // 폼 필드 테두리 옵션
    var borderOption = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    );

    return TextFormField(
      initialValue: viewModel.todoData['todo_name'],
      onChanged: (value) => viewModel.todoData['todo_name'] = value,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: "할일",
          filled: true,
          fillColor: MyColors.light,
          border: borderOption,
          focusedBorder: borderOption,
          errorBorder: borderOption,
          contentPadding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '수정할 할일 제목을 입력해 주세요!';
        }
        return null;
      },
    );
  }
}
