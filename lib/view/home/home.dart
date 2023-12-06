import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/modals/todo_editor.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_list.dart';
import 'package:iww_frontend/view/todo/todo_progress.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

// 홈 레이아웃 및 의존성 주입
class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserInfo user = context.read<UserInfo>();

    return ChangeNotifierProvider<TodoViewModel>(
      create: (context) => TodoViewModel(
        Provider.of<TodoRepository>(context, listen: false),
        Provider.of<UserInfo>(context, listen: false).userId,
      ),
      child: MyTodo(user: user),
    );
  }
}

// ****************************** //
// *                            * //
// *        Todo Screen         * //
// *                            * //
// ****************************** //

class MyTodo extends StatelessWidget {
  final UserInfo user;
  MyTodo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 15,
                child: HomeProfile(
                  user: user, // 프로필 카드
                ),
              ),
              Expanded(
                flex: 10,
                child: TodoProgress(),
              ),
              Expanded(
                flex: 75,
                child: ToDoList(),
              )
            ],
          ),
          // ==== Floating Button ==== //
          Positioned(
            right: 0,
            bottom: 15,
            child: IconButton(
              onPressed: () => showTodoEditModal<TodoViewModel>(context),
              style: IconButton.styleFrom(
                elevation: 1,
                backgroundColor: Colors.orange,
                shadowColor: Colors.black45,
              ),
              icon: Icon(
                size: 40,
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
