import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/home/attendance.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/modals/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_list.dart';
import 'package:iww_frontend/view/todo/todo_progress.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/view/home/attendance.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
    Size screen = MediaQuery.of(context).size;
    double fs = screen.width * 0.01;

    return Container(
      width: screen.width,
      height: screen.height,
      padding: EdgeInsets.only(
        top: 3 * fs,
        left: 3 * fs,
        right: 3 * fs,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 45 * fs, child: TodoProgress()),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Expanded(
                    child: Attendance(
                  attDays: user.attendance,
                )),
              ),
              Expanded(
                child: ToDoList(),
              )
            ],
          ),
          // ==== Floating Button ==== //
          Positioned(
            right: 3 * fs,
            bottom: 8 * fs,
            child: IconButton(
              onPressed: () async {
                showTodoEditModal<TodoViewModel>(context);

                final assetsAudioPlayer = AssetsAudioPlayer();

                assetsAudioPlayer.open(
                  Audio("assets/main.mp3"),
                );

                assetsAudioPlayer.play();
              },
              style: IconButton.styleFrom(
                elevation: 10.0,
                backgroundColor: AppTheme.PRI_COLOR,
                shadowColor: Colors.black45,
              ),
              icon: Icon(
                size: 10 * fs,
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
