import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;

    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    bool isDelayed = DateTime.parse(widget.todo.todoDate).isBefore(yesterday);

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
      ))),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
              side: BorderSide(color: Colors.black54),
              shape: CircleBorder(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todo.todoName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  widget.todo.todoDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDelayed ? Colors.red.shade600 : Colors.black54,
                  ),
                )
              ],
            ),
            widget.todo.grpId == null
                ? SizedBox(width: 0)
                : Icon(Icons.groups_outlined)
          ]),
    );
  }
}
