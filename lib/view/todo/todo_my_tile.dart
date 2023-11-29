import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// TodoList의 개별 타일
class MyTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoViewModel viewModel;

  const MyTodoTile({
    super.key,
    required this.todo,
    required this.viewModel,
  });

  @override
  State<MyTodoTile> createState() => _MyTodoTileState();
}

// 타일 상태
class _MyTodoTileState extends State<MyTodoTile> {
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
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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

  // ****************************** //
  // *                            * //
  // *       On Todo Check        * //
  // *                            * //
  // ****************************** //

  // 할일 체크했을때의 로직
  Future<void> _onTodoCheck(bool value, bool isGroup) async {
    // 개인 todo 인 경우 UI 업데이트
    final todomodel = context.read<TodoViewModel>();
    await todomodel.checkTodo(widget.todo, value).then((value) {
      _handleTodoCashReward(context: context, value: value);
    });
  }

  // ****************************** //
  // *                            * //
  // *        Cash Reward         * //
  // *                            * //
  // ****************************** //

  // 리워드 지급
  void _handleTodoCashReward({
    required BuildContext context,
    required bool value,
  }) {
    final usermodel = context.read<UserProvider>();
    final todomodel = context.read<TodoViewModel>();

    if (value == true) {
      // 펫 경험치 업데이트
      usermodel.petExp += 10;

      // 유저 Hp 업데이트

      var cash = todomodel.isTodaysFirstTodo ? 100 : 10;
      usermodel.userCash += cash;

      // UI
      if (todomodel.notifyUser) {
        _showFirstTodoDoneModal(context);
        todomodel.notifyUser = false;
        return;
      }
      _showCheckSnackBar(context, "할일이 완료되었어요! +$cash");
    } else {
      // 펫 경험치 업데이트

      // 유저 Hp 업데이트

      // 오늘의 마지막 투두이면
      var cash = todomodel.getTodaysChecked(DateTime.now()) == 1 ? 100 : 10;
      usermodel.userCash -= cash;

      _showCheckSnackBar(context, "할일을 취소했어요 -$cash");
    }
  }

  // 스낵바를 보여줍니다
  void _showCheckSnackBar(BuildContext context, String message) {
    showCustomSnackBar(
      context,
      text: message,
      icon: Lottie.asset(
        "assets/star.json",
        animate: true,
      ),
    );
  }

  // * 첫 투두 완료 모달 *//
  Future<void> _showFirstTodoDoneModal(BuildContext context) async {
    // 위젯 빌드 후에 모달 표시
    Future.microtask(() async {
      await showCustomFullScreenModal(
        context,
        TodoFirstDoneModal(),
      );
    });
  }
}
