// 투두리스트 화면
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/widget/todo/layout/list-tile.dart';
import 'package:iww_frontend/view/widget/todo/todo-editor.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ToDoList extends StatelessWidget {
  final scroll = ScrollController();
  final _formKey = GlobalKey<FormState>();

  ToDoList({super.key});

  // 할일 삭제
  _deleteTodo(BuildContext context, int todoId) {
    final viewModel = context.read<TodoViewModel>();

    onPressed(BuildContext context) async {
      // TODO - 할일 삭제
      Navigator.pop(context);

      await viewModel.deleteTodo(todoId).then((response) {
        if (response == true) {
          Provider.of<TodoViewModel>(context, listen: false).fetchTodos();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('삭제가 완료 되었어요!'),
            ),
          );
        }
      });
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('할일을 삭제하시겠어요?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => onPressed(context),
            child: Text('할일을 삭제할래요!'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            print('취소 선택');
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
      ),
    );
  }

  // 할일 수정
  _editTodo(BuildContext context, Todo todo) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (bottomSheetContext) {
          return ChangeNotifierProvider(
              create: (_) => TodoEditorViewModel(
                    todoRepository,
                    authService,
                    todo,
                  ),
              child: TodoEditorModal(
                todo: todo,
                title: "할일 수정",
                formKey: _formKey,
                todoViewModel: Provider.of<TodoViewModel>(
                  context,
                  listen: false,
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    // 데이터 가져오기
    final viewModel = context.watch<TodoViewModel>();
    viewModel.fetchTodos();

    return Column(children: [
      Expanded(
        flex: 1,
        child: TodoListHeader(),
      ),
      Expanded(
          flex: 5,
          // for async data 렌더링
          child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: viewModel.todos.isEmpty
                  ? Lottie.asset(
                      'assets/spinner.json',
                      repeat: true,
                      animate: true,
                      width: 50,
                      height: 50,
                    )
                  : ListView.builder(
                      controller: scroll,
                      itemCount: viewModel.todos.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onLongPress: () {
                            print('길게 눌렀을떄, $idx');
                            _deleteTodo(context, viewModel.todos[idx].todoId);
                          },
                          onTap: () async {
                            print('그냥 짧게 눌렀을때,');
                            _editTodo(context, viewModel.todos[idx]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: TodoListTileLayout(
                              todo: viewModel.todos[idx],
                            ),
                          ),
                        );
                      })))
    ]);
  }

  // TODO - 실제파일 들어오면 버튼 위치 변경하기
  // if (widget.showAddTodo) AddTodo()
  // AddTodo(getData: _fetchTodos(context))
}

// 할일 목록 헤더
class TodoListHeader extends StatelessWidget {
  TodoListHeader({super.key});

  final _formKey = GlobalKey<FormState>();

  // 클릭하면 추가
  _onTap(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (bottomSheetContext) {
          return ChangeNotifierProvider(
              create: (_) => TodoEditorViewModel(
                    todoRepository,
                    authService,
                    null,
                  ),
              child: TodoEditorModal(
                  todo: null,
                  title: "할일 추가",
                  formKey: _formKey,
                  todoViewModel: Provider.of<TodoViewModel>(
                    context,
                    listen: false,
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade700,
      ),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${today.month}월 ${today.day}일",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "오늘의 할일은 무엇인가요?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton.filled(
                  onPressed: () => _onTap(context),
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue.shade700,
                    size: 25,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// 할일이 없는 경우 화면
class TodoListEmpty extends StatelessWidget {
  const TodoListEmpty({
    super.key,
  });

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
