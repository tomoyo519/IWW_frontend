import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';

// TodoList의 개별 타일
class TodoListTileLayout extends StatelessWidget {
  final Todo todo;

  const TodoListTileLayout({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      // padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    //TODO _toggleTodoStatus(int todoId, bool? value);
                  },
                  side: BorderSide(color: Colors.black54),
                  shape: CircleBorder(),
                  checkColor: Colors.blue,
                )),
            Expanded(
              child: Text(
                todo.todoName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            todo.grpId == null
                ? SizedBox(width: 0)
                : Icon(Icons.groups_outlined)
          ]),
    );
  }
}
