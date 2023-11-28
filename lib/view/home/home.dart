import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/todo/todo-editor.dart';
import 'package:iww_frontend/view/todo/todo-list.dart';
import 'package:iww_frontend/view/todo/todo_progress.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final _formKey = GlobalKey<FormState>();

  List<ChangeNotifierProvider> _getProviders(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);
    return [
      ChangeNotifierProvider<TodoViewModel>(
          create: (_) => TodoViewModel(todoRepository, user)),
    ];
  }

  // 클릭하면 할일 추가 모달 띄우기
  _onClickTodoAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => TodoEditorViewModel(
            Provider.of<TodoRepository>(
              context,
              listen: false,
            ),
            null,
          ),
          child: TodoEditorModal(
            todo: null,
            title: "할일 추가",
            formKey: _formKey,
            buildContext: context,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);

    return Scaffold(
      backgroundColor: MyColors.light,
      appBar: MyAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: (Colors.black),
          ),
          IconButton(
            onPressed: () => GlobalNavigator.navigate("/mypage"),
            icon: Icon(Icons.menu),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      // 여기서 뷰모델 주입
      body: MultiProvider(
        providers: _getProviders(context),
        child: MyHome(user: user),
      ),
      bottomNavigationBar: MyBottomNav(
        onAddClick: (context) => _onClickTodoAdd(context),
      ),
    );
  }
}

// 홈 화면
class MyHome extends StatelessWidget {
  const MyHome({
    super.key,
    required this.user,
  });

  final UserInfo user;

  // 이벤트 핸들러
  void _onFirstTodoDone(BuildContext context) {
    LOG.log("First todo done!");
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<TodoViewModel>();

    if (viewmodel.isTodaysFirstTodo == true) {
      _onFirstTodoDone(context);
      viewmodel.isTodaysFirstTodo = false;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 75, // 앱바 영역
          ),
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
    );
  }
}
