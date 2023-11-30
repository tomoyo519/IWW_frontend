import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';
import 'package:iww_frontend/view/pet/evolutionPet.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isGroup = widget.todo.grpId != null;

    final EventService events = context.read<EventService>();
    final TodoViewModel viewModel = context.read<TodoViewModel>();

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
              onChanged: (bool? value) async {
                AppEvent? event = await _onTodoCheck(value!, isGroup);
                // 해당 액션의 결과로 이벤트 발생 시
                // 이벤트 서비스에 넣어서 다음 위젯 빌드 때 체크
                if (event != null) events.input(event);
                // viewModel.waiting = false;
              },
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
  Future<AppEvent?> _onTodoCheck(bool value, bool isGroup) async {
    // 개인 todo 인 경우 UI 업데이트
    final todomodel = context.read<TodoViewModel>();
    return await todomodel.checkTodo(widget.todo, value).then(
          (_) => _handleTodoReward(context: context, value: value),
        );
  }

  // ****************************** //
  // *                            * //
  // *        Cash Reward         * //
  // *                            * //
  // ****************************** //

  // 리워드 지급
  AppEvent? _handleTodoReward({
    required BuildContext context,
    required bool value,
  }) {
    // 할일 리스트에서 상태를 다 갱신하고 들어온다.
    final usermodel = context.read<UserProvider>();
    final todomodel = context.read<TodoViewModel>();

    final now = DateTime.now();
    final todaystodo = todomodel.getTodaysChecked(now);
    final todayformatted = DateFormat('yyyy-MM-dd').format(now);

    // * ==== 펫 경험치 업데이트 ==== * //
    usermodel.petExp += 5 * (value == true ? 1 : -1);

    if (usermodel.petExp > 100) {
      LOG.log("펫 진화 이벤트");
    }

    // * ==== 유저 HP 업데이트 ==== * //
    double rate = (todaystodo / todomodel.total) * 100;
    if (rate > 70) {
      // usermodel.userHp += 10;
    } else {
      // usermodel.userHp -= 10;
    }

    // * ==== 유저 캐시 업데이트 ==== * //
    int reward = 0;
    // 이미 지난 투두를 달성한 경우 보상을 업데이트하지 않음
    if (widget.todo.todoDate.compareTo(todayformatted) < 0) {
      return AppEvent(
        type: AppEventType.snackbar,
        title: "어제 투두를 달성했네요!",
        description: "",
      );
    }
    // 오늘 완료한 투두 개수(방금 갱신됨)가 1이고 완료를 체크했으면
    if (todaystodo == 1 && value == true) {
      usermodel.userCash += 100;

      return AppEvent(
        type: AppEventType.fullmodal,
        title: "first_todo_done",
        description: "앞으로도 더 많은 할일을 달성하세요",
        icon: Icon(
          Icons.money,
        ),
      );
    } else if (todaystodo == 0 && value == false) {
      // 체크값이 false인데 오늘 완료한 투두 개수 (방금 갱신됨)가 0이면
      usermodel.userCash -= 100;
      reward = 100;
    } else {
      // 일반 유저 캐시 업데이트
      usermodel.userCash += 10 * (value == true ? 1 : -1);
      reward = 10;
    }

    return AppEvent(
      type: AppEventType.snackbar,
      title: value == true ? "할일을 달성했어요! +$reward" : "할일을 취소했어요 -$reward",
      description: "",
      icon: Icon(
        Icons.money,
      ),
    );
  }
}
