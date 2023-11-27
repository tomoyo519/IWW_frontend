import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/todo/todo-list.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);
    LOG.log("Home loaded ${user.user_name}");

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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          // 배경 이미지
          image: AssetImage("assets/wallpaper.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: HomeProfile(
                user: user,
              ),
            ),
            Expanded(
              flex: 4,
              child: ChangeNotifierProvider<TodoViewModel>(
                create: (context) => TodoViewModel(
                  todoRepository,
                  user,
                ),
                child: ToDoList(),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
