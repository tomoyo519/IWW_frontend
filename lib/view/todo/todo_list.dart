import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/view/modals/todo_editor.dart';
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

  Widget normalTodoBuilder(Todo todo, BuildContext context) {
    final viewmodel = context.watch<TodoViewModel>();

    return GestureDetector(
      onTap: () => showTodoEditModal<TodoViewModel>(context, todo: todo),
      onLongPress: () => _showDeleteModal(context, todo),
      child: MyTodoTile(
        todo: todo,
        viewmodel: viewmodel,
        onCheck: _onNormalTodoChk,
      ),
    );
  }

  Widget groupTodoBuiler(Todo todo, BuildContext context) {
    final viewmodel = context.watch<TodoViewModel>();

    return GestureDetector(
      onTap: () => showTodoEditModal<TodoViewModel>(context, todo: todo),
      onLongPress: () => _showDeleteModal(context, todo),
      child: GroupTodoTile(
        todo: todo,
        viewmodel: viewmodel,
      ),
    );
  }

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
                      // * ==== 개인투두 ==== * //

                      ToggledTodoList(
                        title: "그룹 인증 할일",
                        initialToggle: true,
                        parentCtxt: context,
                        items: groupTodos,
                        itemBuilder: normalTodoBuilder,
                      ),
                      ToggledTodoList(
                        title: "오늘의 할일",
                        initialToggle: true,
                        parentCtxt: context,
                        items: normalTodos,
                        itemBuilder: normalTodoBuilder,
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
    await viewModel.deleteTodo(todo);
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
  _showDeleteModal(BuildContext context, Todo todo) {
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
}

class ToggledTodoList extends StatefulWidget {
  String title;
  List<Todo> items;
  bool initialToggle;
  BuildContext parentCtxt;
  Widget Function(Todo, BuildContext) itemBuilder;

  ToggledTodoList({
    super.key,
    required this.title,
    required this.items,
    required this.parentCtxt,
    required this.itemBuilder,
    required this.initialToggle,
  });

  @override
  State<ToggledTodoList> createState() => _ToggledTodoListState();
}

class _ToggledTodoListState extends State<ToggledTodoList>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialToggle;

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0.5) // 0.5는 180도 회전을 의미
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      isToggled = !isToggled; // 토글 상태 전환
    });

    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1),
            ),
          ),
          width: screen.width,
          height: 50,
          child: GestureDetector(
            onTap: () => _toggle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 1 * pi,
                      child: Icon(Icons.keyboard_arrow_down_rounded),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isToggled ? screen.height * 0.3 : 0,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var item in widget.items)
                widget.itemBuilder(item, widget.parentCtxt),
            ],
          ),
        ),
      ],
    );
  }
}
