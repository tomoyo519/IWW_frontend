import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:iww_frontend/repository/todo.repository.dart';

// TodoList의 개별 타일
class TodoListTileLayout extends StatefulWidget {
  final Todo todo;
  final TodoViewModel viewModel;

  const TodoListTileLayout({
    super.key,
    required this.todo,
    required this.viewModel,
  });

  @override
  State<TodoListTileLayout> createState() => _TodoListTileLayoutState();
}

// 타일 상태
class _TodoListTileLayoutState extends State<TodoListTileLayout> {
  late File _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isGroup = widget.todo.grpId != null;

    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    bool isDelayed = DateTime.parse(widget.todo.todoDate).isBefore(yesterday);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: widget.todo.todoDone,
              onChanged: (bool? value) async => _onTodoCheck(value!, isGroup),
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

  //  할일 체크했을때의 로직
  Future<void> _onTodoCheck(bool value, bool isGroup) async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    // 개인 todo 인 경우 UI 업데이트
    if (!isGroup) {
      LOG.log("Check normal todo! $value");
      return _onNormalTodoCheck(context, value);
    }

    // 그룹 todo 인 경우 사진 인증으로 이동
    // 이미 체크 완료 되어있는 todo 의 체크를 해제하는 경우.
    if (!value) {
      await _onGroupTodoUncheck(context).then((value) {
        LOG.log("Check group todo ${value == null ? 'Failed' : 'Success'}");
      });
      return;
    }

    // 체크가 되어있지 않은 todo를 사진전송 하고 완료 처리 하는 경우,
    final pickedFile = await _picker
        .pickImage(source: ImageSource.camera)
        .onError((error, stackTrace) {
      // 사용자가 권한거부하여 picker 창이 종료된 경우
      LOG.log("Error while opening image picker! $error");
      return null;
    });

    LOG.log(pickedFile.toString());

    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      final formattedDate = formatter.format(now);

      if (context.mounted) {
        _onGroupTodoCheck(context, pickedFile, formattedDate);
      }
    }
  }

  // 개인 투두를 체크한 경우
  void _onNormalTodoCheck(BuildContext context, bool done) {
    final viewModel = context.read<TodoViewModel>();
    viewModel.checkTodo(widget.todo, done).then((value) {
      if (done) {
        _showCheckSnackBar(context, "할일이 완료되었어요!");
      }
    });
  }

  // 그룹 투두를 체크한 경우
  Future<Object?> _onGroupTodoCheck(
    BuildContext context,
    XFile pickedFile,
    String formattedDate,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return AlertDialog(
          actions: [
            TextButton(
              child: Text('할일 완료!'),
              onPressed: () async {
                final viewModel = context.read<TodoViewModel>();
                final result = await viewModel.checkTodo(
                  widget.todo,
                  true,
                  userId: widget.todo.userId,
                  path: pickedFile.path,
                );
                LOG.log('result : $result');
                LOG.log('context.mounted:${context.mounted}');
                if (result == true && context.mounted) {
                  Navigator.pop(context);
                  _showCheckSnackBar(context, "할일 완료되었어요!");
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
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // 그룹 투두를 체크 해제한 경우
  Future<Object?> _onGroupTodoUncheck(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return AlertDialog(
          actions: [
            Row(
              children: [
                TextButton(
                  child: Text('할일 체크를 해제할래요.'),
                  onPressed: () async {
                    final viewModel = context.read<TodoViewModel>();
                    final result = await viewModel.checkTodo(
                      widget.todo,
                      false,
                      userId: widget.todo.userId,
                      path: "",
                    );
                    if (result == true && context.mounted) {
                      Navigator.pop(context);
                      _showCheckSnackBar(context, "할일 체크 해제 되었어요!");
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
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // 스낵바를 보여줍니다
  void _showCheckSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
