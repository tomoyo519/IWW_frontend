// 투두리스트 화면
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/widget/todo/layout/list-tile.dart';
import 'package:iww_frontend/view/widget/todo/todo-editor.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class ToDoList extends StatelessWidget {
  final scroll = ScrollController();
  final _formKey = GlobalKey<FormState>();

  ToDoList({super.key});

  // 할일 가져오기
  _fetchTodos(BuildContext context) async {
    final viewModel = context.read<TodoViewModel>();
    return await viewModel.fetchTodos();
  }

  // 할일 삭제
  _deleteTodo(BuildContext context, int todoId) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('할일을 삭제하시겠어요?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              // TODO - 할일 삭제
              Navigator.pop(context);

              // TODO - repository로 옮김
              await RemoteDataSource.delete('/todo/$todoId').then((response) {
                if (response.statusCode != 200) {
                  log("Failed to delete todo: ${response.body}");
                } else {
                  _fetchTodos(context);
                }
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('삭제가 완료 되었어요!'),
                    // action: SnackBarAction(
                    //   label: 'Action',
                    //   onPressed: () {
                    //   },
                    // ),
                  ),
                );
              }
            },
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

  // TODO - todo_label 이 왜 etc로 되어있나...?
  _editTodo(BuildContext context, Todo todo) {
    // todo 를 수정하는 화면에서 bottom modal
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
                refresh: _fetchTodos,
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();
    return Column(children: [
      Expanded(
        flex: 1,
        child: TodoListHeader(),
      ),
      Expanded(
        flex: 5,
        // for async data 렌더링
        child: FutureBuilder(
          future: viewModel.fetchTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // data fetch 대기
              return Container(
                width: 400,
                height: 400,
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator(
                  color: MyColors.primary,
                ),
              );
            } else if (snapshot.hasError) {
              // data fetch 오류
              return Text("Error loading page ${snapshot.error}");
            } else if (snapshot.hasData) {
              // data fetch 완료
              List<Todo> todos = snapshot.data!;
              return ListView.builder(
                  controller: scroll,
                  itemCount: todos.length,
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onLongPress: () {
                        print('길게 눌렀을떄, $idx');
                        _deleteTodo(context, todos[idx].todoId);
                      },
                      onTap: () async {
                        print('그냥 짧게 눌렀을때,');
                        _editTodo(context, todos[idx]);
                      },
                      child: TodoListTileLayout(todo: todos[idx]),
                    );
                  });
            } else {
              // 만약 데이터가 없는 경우
              return TodoListEmpty();
            }
          },
        ),
      ),

      // TODO - 실제파일 들어오면 버튼 위치 변경하기
      // if (widget.showAddTodo) AddTodo()
      // AddTodo(getData: _fetchTodos(context))
    ]);
  }
}

// 할일 목록 헤더
class TodoListHeader extends StatelessWidget {
  const TodoListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    final viewModel = context.read<TodoViewModel>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 228, 131, 35),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
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
                  onPressed: () {},
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromARGB(255, 219, 162, 109)),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
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
