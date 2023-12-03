import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
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
                            onCheck: _onNormalTodoChk,
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
  Future<void> _onNormalTodoChk(
      BuildContext context, Todo todo, bool value) async {
    // 개인 todo 인 경우 UI 업데이트
    final todomodel = context.read<TodoViewModel>();
    final usermodel = context.read<UserInfo>();
    int userId = usermodel.userId;

    todomodel.checkTodoState(todo, value, userId, null);
    usermodel.setStateFromTodo(value, false, todomodel.check);

    // * ===== UI UPDATED ===== * //

    // 리워드 계산
    TodoUpdateDto? result = await todomodel.checkTodo(todo.todoId, value);

    // expect data와 현재 상태를 비교하고 필요시 새로 fetch합니다.
    if (result == null || // 응답이 없음
            result.todoDone != value || // 투두 체크 실패
            result.userCash != usermodel.userCash // 유저 보상 오류
        ) {
      usermodel.waiting = true;
      usermodel.fetchUser();
      // todomodel.fetchTodos();
    }
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
    final viewModel = context.read<EditorModalViewModel>();
    await viewModel.updateTodo().then((result) {
      if (result == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('변경이 완료 되었어요!'),
            ),
          );
          Navigator.pop(context);
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
