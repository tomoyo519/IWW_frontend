import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/view/todo/layout/list-tile.dart';
import 'package:iww_frontend/view/todo/todo-editor.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:provider/provider.dart';

class ToDoList extends StatelessWidget {
  final scroll = ScrollController();
  final _formKey = GlobalKey<FormState>();

  ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    // 데이터 가져오기
    final viewModel = context.watch<TodoViewModel>();
    final todos = viewModel.todos;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: viewModel.waiting
          ? Spinner()
          : ListView.builder(
              controller: scroll,
              itemCount: todos.length,
              itemBuilder: (context, idx) {
                // 할일이 없는 경우 디폴트 화면
                if (todos.isEmpty) {
                  return _TodoListEmpty();
                }
                // 할일이 있으면 리스트 렌더링
                return GestureDetector(
                  onTap: () => _showTodoEditor(context, todos[idx]),
                  onLongPress: () => _showTodoDeleteModal(context, todos[idx]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TodoListTileLayout(
                      todo: todos[idx],
                      viewModel: viewModel,
                    ),
                  ),
                );
              },
            ),
    );
  }

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
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => TodoEditorViewModel(
            todo: todo,
            user: userInfo,
            todoRepository: todoRepository,
          ),
          child: TodoEditorModal(
            todo: todo,
            title: "할일 수정",
            formKey: _formKey,
            onSave: (context) => _updateTodo(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
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

    final viewModel = context.read<TodoEditorViewModel>();
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
