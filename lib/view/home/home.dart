import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_list.dart';
import 'package:iww_frontend/view/todo/todo_progress.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

// 홈 레이아웃 및 의존성 주입
class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserInfo user = Provider.of<UserInfo>(context, listen: false);

    return MultiProvider(
      providers: _getProviders(context),
      child: Builder(builder: (context) {
        return MyTodo(user: user);
      }),
    );
  }

  // ==== Helper ==== //
  T _findContext<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  // ==== Helper ==== //
  List<ChangeNotifierProvider> _getProviders(BuildContext context) {
    final UserInfo user = _findContext<UserInfo>(context);
    final TodoRepository repository = _findContext<TodoRepository>(context);

    return [
      ChangeNotifierProvider<TodoViewModel>(
          create: (_) => TodoViewModel(repository, user)),
    ];
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
    // Future.microtask(() {
    //   showCustomFullScreenModal(
    //     context,
    //     EvolPetModal(),
    //   );
    // });

    // return Text("Hello World");

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
              onPressed: () => _showTodoEditor(context),
              style: IconButton.styleFrom(
                elevation: 1,
                backgroundColor: Colors.orange,
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Color.fromARGB(255, 255, 211, 169),
                //     Color.fromARGB(255, 233, 255, 250)
                //   ], // Gradient colors
                // ),
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

  // 클릭하면 할일 추가 모달 띄우기
  Future<void> _showTodoEditor(BuildContext context) async {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    final todoviewmodel = context.read<TodoViewModel>().check;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            user: userInfo,
            parent: null,
          ),
          child: EditorModal(
            init: null,
            title: "할일 추가",
            formKey: _formKey,
            onSave: (context) async {
              if (await _createTodo(context) == true) {
                LOG.log("할일 추가 완료");
                if (context.mounted) {
                  showCustomSnackBar(
                    context,
                    text: "할일이 추가되었어요!",
                    icon: Icon(Icons.check),
                  );
                }
              } else {
                LOG.log("뭔가이상..");
              }
            },
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );

    // .then((value) {
    //   if (value == true) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: const Text('할일이 추가되었어요!'),
    //       ),
    //     );
    //   }
    //   // context.watch<TodoViewModel>().waiting = false;
    // }
  }

  // ==== 할일 신규 생성 ==== //
  Future<bool> _createTodo(BuildContext context) async {
    Navigator.pop(context);

    final editormodel = context.read<EditorModalViewModel>();
    return await editormodel.createTodo().then((result) {
      if (result == true && context.mounted) {
        // 할일 추가 성공
        Navigator.pop(context);
        return true;
      }
      return false;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
