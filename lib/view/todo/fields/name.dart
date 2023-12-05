import 'package:flutter/material.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

// 할일 제목 필드
class TodoNameField extends StatelessWidget {
  TextEditingController? controller;
  FocusNode? focusNode;

  TodoNameField({
    super.key,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EditorModalViewModel>();
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
      // autofocus: true,
      // focusNode: focusNode,
      // controller: controller,
      // focusNode: ,
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return '수정할 할일 제목을 입력해 주세요!';
      //   }
      //   return null;
      // },
    );
  }
}
