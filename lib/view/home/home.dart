import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
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
// *        Home Screen         * //
// *                            * //
// ****************************** //

class MyTodo extends StatelessWidget {
  final UserInfo user;
  final _formKey = GlobalKey<FormState>();
  MyTodo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
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
              onPressed: () => showTodoCreateModal(context),
              style: IconButton.styleFrom(
                elevation: 1,
                backgroundColor: Colors.orange,
                shadowColor: Colors.black45,
              ),
              icon: Icon(
                size: 30,
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///** 투두 생성 모달을 보여주는 메소드
  /// BaseTodoViewModel을 구현하는 클래스가
  /// context 안에 존재하는 경우 사용 가능
  /// */
  void showTodoCreateModal(BuildContext context) {
    FocusNode focusNode = FocusNode();
    TextEditingController controller = TextEditingController();
    UserInfo userInfo = context.read<UserInfo>();
    TodoViewModel viewmodel = context.read<TodoViewModel>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) {
        double keyboardHeight = MediaQuery.of(c).viewInsets.bottom;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: userInfo),
            ChangeNotifierProvider.value(value: viewmodel),
            ChangeNotifierProvider(create: (_) => TodoModalViewModel())
          ],
          child: TodoCreateModal(
            focusNode: focusNode,
            controller: controller,
            mode: TodoModalMode.normal,
            keyboardHeight: keyboardHeight,
          ),
        );

        // ChangeNotifierProvider<TodoModalViewModel>(
        //   create: (_) => TodoModalViewModel(),
        //   child: TodoCreateModal(
        //     controller: controller,
        //     focusNode: focusNode,
        //     keyboardHeight: keyboardHeight,
        //   ),
        // );
      },
    );
  }

  // TextEditingController _controller =
  // 클릭하면 할일 추가 모달 띄우기
  Future<void> _showTodoEditor(BuildContext context) async {
    final userInfo = context.read<UserInfo>();
    final todoviewmodel = context.read<TodoViewModel>();
    TextEditingController controller = TextEditingController();
    FocusNode focusNode = FocusNode();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            user: userInfo,
            parent: todoviewmodel,
          ),
          child: EditorModal(
            init: null,
            title: "할일 추가",
            onSave: (context) async {
              Navigator.pop(context);
              await _createTodo(context);
            },
            onCancel: (context) => Navigator.pop(context),
            focusNode: focusNode,
            controller: controller,
          ),
        );
      },
    );
  }

  // ==== 할일 신규 생성 ==== //
  Future<bool> _createTodo(BuildContext context) async {
    final editormodel = context.read<EditorModalViewModel>();
    return await editormodel.createTodo().then((result) {
      if (result == true && context.mounted) {
        return true;
      }
      return false;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
