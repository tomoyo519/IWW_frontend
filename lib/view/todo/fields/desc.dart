import 'package:flutter/material.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoDescField extends StatefulWidget {
  TodoDescField({super.key});

  @override
  State<TodoDescField> createState() => _TodoDescFieldState();
}

class _TodoDescFieldState extends State<TodoDescField> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditorModalViewModel>(
      context,
      listen: false,
    );
    return GestureDetector(
        onTap: () => setState(() {
              isClicked = true;
            }),
        child: TodoFormFieldLayout(
          icon: Icons.sticky_note_2_outlined,
          child: TextField(
            onChanged: (value) => viewModel.todoDesc = value,
            decoration: InputDecoration(
              hintText: "예) 1만보 걷기",
              hintStyle: TextStyle(fontSize: 15.0), // 글자 크기를 18.0으로 설정
              fillColor: Colors.grey[200],
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ));
  }
}
