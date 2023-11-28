import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/todo/todo-editor.dart';
import 'package:iww_frontend/view/todo/todo-list.dart';
import 'package:iww_frontend/view/todo/todo_progress.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

// 홈 레이아웃 및 의존성 주입
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
  _showTodoEditor(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => TodoEditorViewModel(
            user: userInfo,
            todoRepository: todoRepository,
          ),
          child: TodoEditorModal(
            todo: null,
            title: "할일 추가",
            formKey: _formKey,
            onSave: (context) => _createTodo(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    ).then((value) {
      // 화면을 리프레시합니다.
      // context.watch<TodoViewModel>().waiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);

    return MultiProvider(
      providers: _getProviders(context),
      child: Builder(builder: (context) {
        return Scaffold(
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

          body: MyHome(user: user),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: MyBottomNav(
            onAddClick: (_) => _showTodoEditor(context),
          ),

          // ==== Styles ==== //
          backgroundColor: MyColors.light,
        );
      }),
    );
  }

  // 할일 신규 생성
  void _createTodo(BuildContext context) async {
    Navigator.pop(context);

    final viewModel = context.read<TodoEditorViewModel>();

    LOG.log('${viewModel.todoData} viewModel.todoData');
    await viewModel.createTodo().then((result) {
      if (result == true && context.mounted) {
        LOG.log('onsave일떄');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('할일이 추가되었어요!'),
          ),
        );
      }
    });
  }
}

// ****************************** //
// *                            * //
// *        Home Screen         * //
// *                            * //
// ****************************** //

class MyHome extends StatelessWidget {
  final UserInfo user;
  const MyHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<TodoViewModel>();
    final notifyUser = viewmodel.notifyUser;

    if (notifyUser && viewmodel.isTodaysFirstTodo) {
      _onFirstTodoDone(context);
      viewmodel.notifyUser = false;
    }

    if (notifyUser && !viewmodel.isTodaysFirstTodo) {
      _onFirstTodoDone(context);
      viewmodel.notifyUser = false;
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

  // * 첫 투두 완료 모달 *//
  Future<void> _onFirstTodoDone(BuildContext context) async {
    // 위젯 빌드 후에 모달 표시
    Future.microtask(() async {
      await showCustomFullScreenModal(
        context,
        TodoFirstDoneModal(),
      );
    });
  }
}
