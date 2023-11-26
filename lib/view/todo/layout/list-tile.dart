import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:iww_frontend/repository/todo.repository.dart';

// TodoList의 개별 타일
class TodoListTileLayout extends StatefulWidget {
  final Todo todo;

  const TodoListTileLayout({
    super.key,
    required this.todo,
  });

  @override
  State<TodoListTileLayout> createState() => _TodoListTileLayoutState();
}

class _TodoListTileLayoutState extends State<TodoListTileLayout> {
  bool isChecked = false;
  late File _imageFile;
  final _picker = ImagePicker();

  void _onCheck(BuildContext context, bool? value) {
    final viewModel = context.read<TodoViewModel>();
    // viewModel.checkTodo(widget.todo.todoId, value ?? false);
    viewModel.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.todo.todoDone;

    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    bool isDelayed = DateTime.parse(widget.todo.todoDate).isBefore(yesterday);
    String getFormattedDate() {
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(now);
    }

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
      ))),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: widget.todo.todoDone,
              onChanged: (bool? value) async {
                _onCheck(context, value);

                // 그룹 todo 인 경우 사진 인증으로 이동

                //이미 체크 완료 되어있는 todo 의 체크를 해제하는 경우.
                if (!value!) {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return AlertDialog(
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                child: Text('할일 체크를 해제할래요.'),
                                onPressed: () async {
                                  final viewModel =
                                      context.read<TodoViewModel>();
                                  final result = await viewModel.checkTodo(
                                      widget.todo.userId,
                                      widget.todo.todoId,
                                      false,
                                      "");
                                  if (result == true && context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("할일 체크 해제 되었어요!")));
                                    viewModel.fetchTodos();
                                  }
                                },
                              ),
                              TextButton(
                                child: Text('취소'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        ],
                        content: Text("완료처리가 되어있는 할일이에요.\n할일 체크를 해제하시겠어요?"),
                      );
                    },
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 300),
                  );
                }

                // 체크가 되어있지 않은 todo를 사진전송 하고 완료 처리 하는 경우,
                if (widget.todo.grpId != null && value!) {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  print(pickedFile);
                  if (pickedFile != null) {
                    setState(() => _imageFile = File(pickedFile.path));
                    final formattedDate = getFormattedDate();
                    // ignore: use_build_context_synchronously
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (BuildContext buildContext,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                              child: Text('할일 완료!'),
                              onPressed: () async {
                                final viewModel = context.read<TodoViewModel>();
                                final result = await viewModel.checkTodo(
                                    widget.todo.userId,
                                    widget.todo.todoId,
                                    true,
                                    pickedFile.path);

                                if (result == true && context.mounted) {
                                  viewModel.fetchTodos();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("할일 완료되었어요!")));
                                }
                              },
                            )
                          ],
                          content: Expanded(
                              child: Stack(
                            children: [
                              Image.file(_imageFile),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        );
                      },
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }
                }

                setState(() {
                  isChecked = value!;
                });
              },

              // onChanged: (bool? value) => _onCheck(context, value),

              side: BorderSide(color: Colors.black54),
              shape: CircleBorder(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.todoName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          widget.todo.todoDone ? Colors.black26 : Colors.black,
                    ),
                  ),
                  Text(
                    widget.todo.todoDate,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.todo.todoDone
                          ? Colors.black26
                          : isDelayed
                              ? Colors.red.shade600
                              : Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            widget.todo.grpId == null
                ? SizedBox(width: 0)
                : Icon(Icons.groups_outlined)
          ]),
    );
  }
}
