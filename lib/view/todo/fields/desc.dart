import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/view/custom-bottom-sheet-header.dart';
import 'package:iww_frontend/view/widget/todo/layout/form-field.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoDescField extends StatelessWidget {
  const TodoDescField({super.key});

  _onTap(BuildContext context) {
    final viewModel = Provider.of<TodoEditorViewModel>(
      context,
      listen: false,
    );
    showModalBottomSheet(
        context: context,
        builder: (bottomSheetContext) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                MyBottomSheetModalHeader(
                  title: "설명 추가",
                  onCancel: () {},
                  onSave: () {},
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("완료")),
                TextFormField(
                  initialValue: viewModel.todoData['todo_desc'] ?? "",
                  onChanged: (value) => viewModel.todoDesc = value,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: TodoFormFieldLayout(
        icon: Icons.sticky_note_2_outlined,
        child: Text("작업 설명 추가"),
      ),
    );
  }
}
