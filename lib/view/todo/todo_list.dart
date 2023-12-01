import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/view/todo/todo_my_tile.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_group_tile.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';
import 'package:provider/provider.dart';

class ToDoList extends StatelessWidget {
  final scroll = ScrollController();
  final _formKey = GlobalKey<FormState>();

  ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    // 데이터 가져오기
    final viewModel = context.watch<TodoViewModel>();
    final groupTodos = viewModel.groupTodos;
    final todos = viewModel.todos;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: viewModel.waiting
          ? Spinner()
          : viewModel.groupTodos.isEmpty && viewModel.todos.isEmpty
              ? _TodoListEmpty()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: 이런식으로 섹션 나누지 말고
                      // TODO: 그룹 또는 개인투두가 없는 경우 등등을 고려해야함.
                      // * ==== 그룹투두 ==== * //
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Group Todo",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (var todo in groupTodos)
                        GestureDetector(
                          onTap: () => _showTodoEditor(context, todo),
                          onLongPress: () =>
                              _showTodoDeleteModal(context, todo),
                          child: GroupTodoTile(
                            todo: todo,
                            viewModel: viewModel,
                          ),
                        ),
                      // * ==== 개인투두 ==== * //
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Personal Todo",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (var todo in todos)
                        GestureDetector(
                          onTap: () => _showTodoEditor(context, todo),
                          onLongPress: () =>
                              _showTodoDeleteModal(context, todo),
                          child: MyTodoTile(
                            todo: todo,
                            viewModel: viewModel,
                            onCheck: _onMyTodoCheck,
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  // ****************************** //
  // *                            * //
  // *       On Todo Check        * //
  // *                            * //
  // ****************************** //

  // 할일 체크했을때의 로직
  Future<AppEvent?> _onMyTodoCheck(
    BuildContext context,
    Todo todo,
    bool value,
    // bool isGroup,
  ) async {
    // 개인 todo 인 경우 UI 업데이트
    final todomodel = context.read<TodoViewModel>();
    return await todomodel.checkTodo(todo, value).then(
          (_) => _handleTodoReward(
            context: context,
            value: value,
          ),
        );
  }

  // ****************************** //
  // *                            * //
  // *        Cash Reward         * //
  // *                            * //
  // ****************************** //

  // 리워드 지급
  AppEvent? _handleTodoReward({
    required BuildContext context,
    required bool value,
  }) {
    // 할일 리스트에서 상태를 다 갱신하고 들어온다.
    // final usermodel = context.read<UserProvider>();
    // final todomodel = context.read<TodoViewModel>();

    // final now = DateTime.now();
    // final todaystodo = todomodel.getTodaysChecked(now);

    // // * ==== 펫 경험치 업데이트 ==== * //
    // usermodel.petExp += 5 * (value == true ? 1 : -1);

    // if (usermodel.petExp > 100) {
    //   LOG.log("펫 진화 이벤트");
    // }

    // // * ==== 유저 HP 업데이트 ==== * //
    // double rate = (todaystodo / todomodel.total) * 100;
    // if (rate > 70) {
    //   // usermodel.userHp += 10;
    // } else {
    //   // usermodel.userHp -= 10;
    // }

    // // * ==== 유저 캐시 업데이트 ==== * //
    // int reward = 0;
    // 이미 지난 투두를 달성한 경우 보상을 업데이트하지 않음
    // if (todo.todoDate.compareTo(todayformatted) < 0) {
    //   return AppEvent(
    //     type: AppEventType.snackbar,
    //     title: "어제 투두를 달성했네요!",
    //     description: "",
    //   );
    // }
    // 오늘 완료한 투두 개수(방금 갱신됨)가 1이고 완료를 체크했으면
    // if (todaystodo == 1 && value == true) {
    //   usermodel.userCash += 100;

    //   return AppEvent(
    //     type: AppEventType.fullmodal,
    //     title: "first_todo_done",
    //     description: "앞으로도 더 많은 할일을 달성하세요",
    //     icon: Icon(
    //       Icons.money,
    //     ),
    //   );
    // } else if (todaystodo == 0 && value == false) {
    //   // 체크값이 false인데 오늘 완료한 투두 개수 (방금 갱신됨)가 0이면
    //   usermodel.userCash -= 100;
    //   reward = 100;
    // } else {
    //   // 일반 유저 캐시 업데이트
    //   usermodel.userCash += 10 * (value == true ? 1 : -1);
    //   reward = 10;
    // }

    // return AppEvent(
    //   type: AppEventType.snackbar,
    //   title: value == true ? "할일을 달성했어요! +$reward" : "할일을 취소했어요 -$reward",
    //   description: "",
    //   icon: Icon(
    //     Icons.money,
    //   ),
    // );
  }

  // todo delete modal onclick callback
  Future<void> _onClickDelete(BuildContext context, Todo todo) async {
    Navigator.pop(context);

    final viewModel = context.read<TodoViewModel>();

    await viewModel.deleteTodo(todo.todoId).then((response) {
      LOG.log("Delete todo");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('삭제가 완료 되었어요!'),
        ),
      );
    });
  }

  // todo editor onsave callback
  // 기존 할일 수정
  Future<void> _updateTodo(BuildContext context) async {
    Navigator.pop(context);

    final viewModel = context.read<EditorModalViewModel>();
    await viewModel.updateTodo().then((result) {
      if (result == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('변경이 완료 되었어요!'),
            ),
          );

          // 일정 시간 후에 화면을 닫습니다.
          // Future.delayed(Duration(seconds: 3), () {
          //   if (context.mounted) {
          //     Navigator.pop(context);
          //   }
          // });
        }
      }
    });
  }

  // ****************************** //
  // *                            * //
  // *       Show Modal UI        * //
  // *                            * //
  // ****************************** //

  // 할일 삭제
  _showTodoDeleteModal(BuildContext context, Todo todo) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext buildContext) => CupertinoActionSheet(
        title: Text('할일을 삭제하시겠어요?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => _onClickDelete(context, todo),
            child: Text('할일을 삭제할래요!'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            LOG.log('취소 선택');
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
      ),
    );
  }

  // 할일 수정
  _showTodoEditor(BuildContext context, Todo todo) {
    final todoviewmodel = context.read<TodoViewModel>();
    final userInfo = context.read<UserInfo>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            of: todo,
            user: userInfo,
            parent: todoviewmodel,
          ),
          child: EditorModal(
            init: todo,
            title: "할일 수정",
            formKey: _formKey,
            onSave: (context) => _updateTodo(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }
}

// 할일이 없는 경우 화면
class _TodoListEmpty extends StatelessWidget {
  const _TodoListEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26, width: 1)),
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Text("아직 등록된 할 일이 없습니다. 등록해볼까요?"),
    );
  }
}
