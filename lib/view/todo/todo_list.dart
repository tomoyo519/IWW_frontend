import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/todo/todo_update.dto.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/view/home/attendance.dart';
import 'package:iww_frontend/view/modals/todo_editor.dart';
import 'package:iww_frontend/view/todo/todo_empty.dart';
import 'package:iww_frontend/view/todo/todo_my_tile.dart';
import 'package:iww_frontend/view/todo/todo_group_tile.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ToDoList extends StatefulWidget {
  ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> with TickerProviderStateMixin {
  final scroll = ScrollController();
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<SubTodoList> _sublist;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: 0, end: 0.5) // 0.5는 180도 회전을 의미
        .animate(_controller);

    _sublist = [
      SubTodoList(
        idx: 0,
        title: "그룹 할일",
        items: [],
        isOpen: true,
        builder: groupTodoBuiler,
      ),
      SubTodoList(
        idx: 1,
        title: "나의 할일",
        items: [],
        isOpen: true,
        builder: normalTodoBuilder,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(SubTodoList sub) {
    setState(() {
      sub.isOpen = !sub.isOpen;
    });
    if (_animation.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 데이터 가져오기
    final viewModel = context.watch<TodoViewModel>();
    _sublist[0].items = viewModel.groupTodos;
    _sublist[1].items = viewModel.normalTodos;

    double fs = MediaQuery.of(context).size.width * 0.01;
    UserInfo userinfo = context.read<UserInfo>();

    return viewModel.waiting
        ? Lottie.asset(
            'assets/spinner.json',
            repeat: true,
            animate: true,
            height: MediaQuery.of(context).size.height * 0.3,
          )
        : viewModel.groupTodos.isEmpty && viewModel.todos.isEmpty
            ? TodoListEmpty()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5 * fs),
                      child: Expanded(
                          child: Attendance(
                        attDays: userinfo.attendance,
                      )),
                    ),
                    for (SubTodoList sub in _sublist) ...[
                      GestureDetector(
                        onTap: () async {
                          _toggle(sub);
                          final assetsAudioPlayer = AssetsAudioPlayer();
                          assetsAudioPlayer.open(Audio("assets/main.mp3"));
                          assetsAudioPlayer.play();
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 10 * fs,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sub.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 5 * fs,
                                ),
                              ),
                              if (sub.isOpen == true)
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 6 * fs,
                                )
                              else
                                Icon(
                                  Icons.keyboard_arrow_left,
                                  size: 6 * fs,
                                )
                            ],
                          ),
                        ),
                      ),
                      if (sub.items.isNotEmpty) ...[
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          child: sub.isOpen
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 3 * fs),
                                  child: Column(children: [
                                    for (Todo todo in sub.items)
                                      sub.builder(todo, context)
                                  ]),
                                )
                              : SizedBox(width: double.infinity, height: 0),
                        )
                      ]
                    ]
                  ],
                ),
              );
  }

  // ****************************** //
  Future<void> _onNormalTodoChk(
      BuildContext context, Todo todo, bool value) async {
    // 개인 todo 인 경우 UI 업데이트
    TodoViewModel todomodel = context.read<TodoViewModel>();
    UserInfo usermodel = context.read<UserInfo>();
    int userId = usermodel.userId;

    // 할일 상태를 완료됨으로 변경
    todomodel.checkTodoState(todo, value, userId, null);
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("assets/main.mp3"));
    assetsAudioPlayer.play();

    // 리워드 계산
    TodoCheckDto? result = await todomodel.checkNormalTodo(todo.todoId, value);
    if (result != null) {
      usermodel.handleTodoCheck(result);
    }
  }

  Future<void> _onClickDelete(BuildContext context, Todo todo) async {
    Navigator.pop(context);

    final viewModel = context.read<TodoViewModel>();
    await viewModel.deleteTodo(todo);
  }

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
      // onTap: () => showTodoEditModal<TodoViewModel>(context, todo: todo),
      // onLongPress: () => _showDeleteModal(context, todo),
      child: GroupTodoTile(
        todo: todo,
        viewmodel: viewmodel,
      ),
    );
  }
}

class SubTodoList {
  int idx;
  String title;
  bool isOpen;
  List<Todo> items;
  Widget Function(Todo todo, BuildContext context) builder;

  SubTodoList({
    required this.idx,
    required this.title,
    required this.items,
    required this.isOpen,
    required this.builder,
  });
}
