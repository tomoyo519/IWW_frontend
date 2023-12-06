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
  final TodoViewModel viewmodel;
  final Future<void> Function(BuildContext, Todo, bool) onCheck;

  const MyTodoTile({
    super.key,
    required this.todo,
    required this.viewmodel,
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
        color: Color.fromARGB(255, 246, 246, 246),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.todo.todoDone ? Colors.black26 : Colors.black,
                  ),
                ),
                Text(
                  widget.todo.todoStart,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
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
        ],
      ),
    );
  }
}
