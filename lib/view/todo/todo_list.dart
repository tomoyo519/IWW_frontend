import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/view/todo/todo_empty.dart';
import 'package:iww_frontend/view/todo/todo_my_tile.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_group_tile.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
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
    final normalTodos = viewModel.normalTodos;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: viewModel.waiting
          ? Spinner()
          : viewModel.groupTodos.isEmpty && viewModel.todos.isEmpty
              ? TodoListEmpty()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: 이런식으로 섹션 나누지 말고
                      // TODO: 그룹 또는 개인투두가 없는 경우 등등을 고려해야함.
                      // * ==== 그룹투두 ==== * //
                      if (groupTodos.isNotEmpty) ...[
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
                      ],

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
                      for (var todo in normalTodos)
                        GestureDetector(
                          onTap: () => _showTodoEditor(context, todo),
                          onLongPress: () =>
                              _showTodoDeleteModal(context, todo),
                          child: MyTodoTile(
                            todo: todo,
                            viewModel: viewModel,
                            onCheck: _onNormalTodoChk,
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  // ****************************** //
  // *       On Todo Check        * //
  // ****************************** //

  // 할일 체크했을때의 로직
  Future<void> _onNormalTodoChk(
      BuildContext context, Todo todo, bool value) async {
    // 개인 todo 인 경우 UI 업데이트
    final todomodel = context.read<TodoViewModel>();
    final usermodel = context.read<UserInfo>();
    int userId = usermodel.userId;

    todomodel.checkTodoState(todo, value, userId, null);
    usermodel.setStateFromTodo(value, false, todomodel.todayDone);

    // * ===== ! UI UPDATED ! ===== * //

    // 리워드 계산
    TodoCheckDto? result = await todomodel.checkNormalTodo(todo.todoId, value);
    if (result != null) {
      // 상태 셋
      usermodel.userCash = result.userCash;
      usermodel.itemId = result.itemId ?? usermodel.itemId;
      usermodel.petExp = result.petExp ?? usermodel.petExp;
    }

    // expect data와 현재 상태를 비교하고 필요시 새로 fetch합니다.
    if (result == null || // 응답이 없음
            result.todoDone != value || // 투두 체크 실패
            result.userCash != usermodel.userCash // 유저 보상 오류
        ) {
      LOG.log("Failed to update properly. Fetch data...");
      LOG.log("Expected {done: $value, cash: ${usermodel.userCash}}");
      LOG.log("Current {done: ${result!.todoDone}, cash: ${result.userCash}}");

      await usermodel.fetchUser();
      await todomodel.fetchTodos();
      usermodel.waiting = false;
    }
  }

  // 삭제 모달에서 삭제를 누르면 실행되는 함수
  Future<void> _onClickDelete(BuildContext context, Todo todo) async {
    Navigator.pop(context);

    final viewModel = context.read<TodoViewModel>();

    await viewModel.deleteTodo(todo.todoId).then(
      (response) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  // 투두 에디터에서 저장을 누르면 실행되는 함수
  Future<void> _updateTodo(BuildContext context) async {
    final viewModel = context.read<EditorModalViewModel>();
    await viewModel.updateTodo().then(
      (result) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  // ****************************** //
  // *       Show Modal UI        * //
  // ****************************** //

  // 할일 삭제 모달
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

  // 할일 수정 에디터
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
            onSave: (context) => _updateTodo(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }
}
