import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/extension/string.ext.dart';
import 'package:iww_frontend/utils/extension/timeofday.ext.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';

// 개인 할일 타일
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
    double fs = MediaQuery.of(context).size.width * 0.01;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 3 * fs,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            checkColor: Colors.white,
            activeColor: AppTheme.primary,
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
                    fontSize: 4.5 * fs,
                    fontWeight: FontWeight.w600,
                    color: widget.todo.todoDone ? Colors.black26 : Colors.black,
                  ),
                ),
                Text(
                  toViewDate(widget.todo.todoDate, widget.todo.todoStart),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 3.5 * fs,
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
              ? SizedBox.shrink()
              : Icon(Icons.groups_outlined)
        ],
      ),
    );
  }

  String toViewDate(String dateString, String timeString) {
    String rtn = '';
    DateTime date = dateString.toDateTime()!;
    DateTime now = DateTime.now();
    TimeOfDay time = timeString.toTimeOfDay()!;

    if (date.day != now.day) {
      rtn += DateFormat('MM월 dd일 ').format(date);
    } else {
      rtn += '오늘 ';
    }

    rtn += time.toViewString()!;
    return rtn;
  }
}
