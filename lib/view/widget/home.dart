import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/widget/appbar.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';
import 'package:iww_frontend/view/widget/profile.dart';
import 'package:iww_frontend/view/widget/todo/todo-editor.dart';
import 'package:iww_frontend/view/widget/todo/todo-list.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoAdd extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TodoAdd({super.key});

  // 할일 가져오기
  _fetchTodos(BuildContext context) async {
    final viewModel = context.read<TodoViewModel>();
    return await viewModel.fetchTodos();
  }

  // 클릭하면 추가
  _onTap(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (bottomSheetContext) {
          return ChangeNotifierProvider(
              create: (_) => TodoEditorViewModel(
                    todoRepository,
                    authService,
                    null,
                  ),
              child: TodoEditorModal(
                todo: null,
                title: "할일 추가",
                formKey: _formKey,
                refresh: _fetchTodos,
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onTap(context),
      style: IconButton.styleFrom(
        elevation: 120,
        iconSize: 30,
        shadowColor: Colors.black87,
        backgroundColor: Colors.lime.shade700,
      ),
      icon: Icon(
        Icons.add_circle_outline_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: MyColors.light,
      appBar: MyAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: (Colors.black),
          )
        ],
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Profile(),
        ),
        Expanded(
            flex: 4,
            child: ChangeNotifierProvider<TodoViewModel>(
              create: (context) => TodoViewModel(
                todoRepository,
                authService,
              ),
              child: ToDoList(),
            ))
      ]),
      bottomNavigationBar: MyBottomNav(),
      floatingActionButton: TodoAdd(),
    );
  }
}
