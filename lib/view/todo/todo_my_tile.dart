import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

// TodoList의 개별 타일
class MyTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoViewModel viewModel;
  final Future<void> Function(BuildContext, Todo, bool) onCheck;

  const MyTodoTile({
    super.key,
    required this.todo,
    required this.viewModel,
    required this.onCheck,
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
                // * ==== 투두가 체크되었을 때의 콜백 ==== * //
                // *      See `./todo_list.dart`    * //
                await widget.onCheck(
                  context,
                  widget.todo,
                  value!,
                );
                // 해당 액션의 결과로 이벤트 발생 시
                // 이벤트 서비스에 넣어서 다음 위젯 빌드 때 체크
                // if (event != null) events.publish(event);
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

  // // 할일 체크했을때의 로직
  // Future<AppEvent?> _onTodoCheck(bool value, bool isGroup) async {
  //   // 개인 todo 인 경우 UI 업데이트
  //   final todomodel = context.read<TodoViewModel>();
  //   return await todomodel.checkTodo(widget.todo, value).then(
  //         (_) => _handleTodoReward(context: context, value: value),
  //       );
  // }
}
