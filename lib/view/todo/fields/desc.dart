import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/todo/todo_form_field.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoDescField extends StatefulWidget {
  TodoDescField({super.key});

  @override
  State<TodoDescField> createState() => _TodoDescFieldState();
}

class _TodoDescFieldState extends State<TodoDescField> {
  bool isClicked = false;

  // _onTap(BuildContext context) {
  //   final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

  //   final viewModel = Provider.of<EditorModalViewModel>(
  //     context,
  //     listen: false,
  //   );
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (bottomSheetContext) {
  //       return FractionallySizedBox(
  //         heightFactor: isKeyboardOpen ? 0.9 : 0.58,
  //         child: SizedBox(
  //           height: MediaQuery.of(context).size.height / 2,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 BottomSheetModalHeader(
  //                   title: "설명 추가",
  //                 ),
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text("완료")),
  //                 TextFormField(
  //                   initialValue: viewModel.todoData['todo_desc'] ?? "",
  //                   onChanged: (value) => viewModel.todoDesc = value,
  //                   maxLines: null,
  //                   decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                         borderSide: BorderSide(
  //                       color: Colors.black,
  //                       width: 1,
  //                     )),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
        child: isClicked
            ? TodoFormFieldLayout(
                icon: Icons.sticky_note_2_outlined,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => viewModel.todoDesc = value,
                ),
              )
            : TodoFormFieldLayout(
                icon: Icons.sticky_note_2_outlined,
                child: Text("작업 설명 추가"),
              ));
  }
}
