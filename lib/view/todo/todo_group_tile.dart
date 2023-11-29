import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GroupTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoViewModel viewModel;

  static final List<List<Color>> gradients = [
    [Color(0xffff0f7b), Color(0xfff89b29)],
  ];

  const GroupTodoTile({
    super.key,
    required this.todo,
    required this.viewModel,
  });

  @override
  State<GroupTodoTile> createState() => _GroupTodoTileState();
}

class _GroupTodoTileState extends State<GroupTodoTile> {
  late File _imageFile;

  final _picker = ImagePicker();
  final scroll = ScrollController();
  // final _formKey = GlobalKey<FormState>();

  int todoState = 0;

  @override
  void initState() {
    super.initState();
    // 그룹 투두의 상태를 초기화합니다
    if (!widget.todo.todoDone) {
      // State is undone.
      todoState = 0;
    } else if (widget.todo.todoImg == null) {
      // State is pending.
      todoState = 1;
    } else {
      // State is done.
      todoState = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        // boxShadow: BoxShadow(

        // ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange.shade100,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: GroupTodoTile.gradients[0],
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todo.todoName,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todoState == 2
                      ? TextDecoration.lineThrough // 완료된 경우
                      : TextDecoration.none, // 아직 미완
                  color: todoState == 0 ? Colors.black87 : Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 15,
                  ),
                  Text(
                    widget.todo.todoDate,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              elevation: 0,
              backgroundColor: Colors.transparent, // 버튼의 기본 색상을 투명하게 설정
              shadowColor: Colors.transparent, // 그림자 효과 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 원하는 모서리 둥글기 적용
              ),
            ),
            // 버튼 클릭 시 수행할 작업
            onPressed: () => _onTodoCheck(),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft, // 그라디언트 시작점
                  end: Alignment.bottomRight, // 그라디언트 끝점
                ),
                borderRadius: BorderRadius.circular(8), // 컨테이너 모서리 둥글기
              ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 88,
                  minHeight: 36,
                ), // 버튼 크기 조정
                alignment: Alignment.center,
                child: Text(
                  todoState == 0
                      ? "인증하기"
                      : todoState == 1
                          ? "인증 대기중"
                          : "✔ 인증 완료",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ), // 텍스트 색상
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ****************************** //
  // *                            * //
  // *       On Todo Check        * //
  // *                            * //
  // ****************************** //

  Future<void> _onTodoCheck() async {
    // 이미 체크 완료 되어있는 todo 의 체크를 해제하는 경우.
    if (widget.todo.todoDone) {
      // 체크를 해제합니다
      return await _groupTodoUncheck(context);
    }

    // 체크가 되어있지 않은 todo를 사진전송 하고 완료 처리 하는 경우,
    final pickedFile = await _picker
        .pickImage(source: ImageSource.camera)
        .onError((error, stackTrace) {
      // 사용자가 권한거부하여 picker 창이 종료된 경우
      LOG.log("Error while opening image picker! $error");
      return null;
    });

    LOG.log(pickedFile.toString());

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        LOG.log("image file ${_imageFile.toString()}");
      });
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(DateTime.now());

      if (context.mounted) {
        return _groupTodoCheck(context, pickedFile, formattedDate);
      }
    }
  }

  // 그룹 투두를 체크한 경우
  Future<void> _groupTodoCheck(
    BuildContext context,
    XFile pickedFile,
    String formattedDate,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return AlertDialog(
          actions: [
            TextButton(
              child: Text('할일 완료!'),
              onPressed: () async {
                final viewModel = context.read<TodoViewModel>();
                final result = await viewModel.checkTodo(
                  widget.todo,
                  true,
                  userId: widget.todo.userId,
                  path: pickedFile.path,
                );
                if (result == true && context.mounted) {
                  LOG.log("@@@@@@@@@@@@@@@");
                  Navigator.pop(context);
                  _handleTodoCashReward(context: context, value: true);
                }
              },
            )
          ],
          content: Expanded(
              child: Stack(
            children: [
              Image.file(_imageFile),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          )),
        );
      },
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _groupTodoUncheck(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return AlertDialog(
          actions: [
            Row(
              children: [
                TextButton(
                  child: Text('할일 체크를 해제할래요.'),
                  onPressed: () async {
                    final viewModel = context.read<TodoViewModel>();
                    final result = await viewModel.checkTodo(widget.todo, false,
                        userId: widget.todo.userId, path: "");
                    if (result == true && context.mounted) {
                      Navigator.pop(context);
                      _handleTodoCashReward(context: context, value: false);
                    }
                  },
                ),
                TextButton(
                  child: Text('취소'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
          content: Text("완료처리가 되어있는 할일이에요.\n할일 체크를 해제하시겠어요?"),
        );
      },
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // ****************************** //
  // *                            * //
  // *        Cash Reward         * //
  // *                            * //
  // ****************************** //

  // 리워드 지급
  void _handleTodoCashReward({
    required BuildContext context,
    required bool value,
  }) {
    final usermodel = context.read<UserProvider>();
    final todomodel = context.read<TodoViewModel>();

    if (value == true) {
      // 펫 경험치 업데이트
      usermodel.petExp += 10;

      // 유저 Hp 업데이트

      var cash = todomodel.isTodaysFirstTodo ? 100 : 25;
      usermodel.userCash += cash;

      // UI
      if (todomodel.notifyUser) {
        _showFirstTodoDoneModal(context);
        todomodel.notifyUser = false;
        return;
      }
      _showCheckSnackBar(context, "할일이 완료되었어요! +$cash");
    } else {
      // 펫 경험치 업데이트

      // 유저 Hp 업데이트

      // 오늘의 마지막 투두이면
      var cash = todomodel.getTodaysChecked(DateTime.now()) == 1 ? 100 : 25;
      usermodel.userCash -= cash;

      _showCheckSnackBar(context, "할일을 취소했어요 -$cash");
    }
  }

  // 스낵바를 보여줍니다
  void _showCheckSnackBar(BuildContext context, String message) {
    showCustomSnackBar(
      context,
      text: message,
      icon: Lottie.asset(
        "assets/star.json",
        animate: true,
      ),
    );
  }

  // * 첫 투두 완료 모달 *//
  Future<void> _showFirstTodoDoneModal(BuildContext context) async {
    // 위젯 빌드 후에 모달 표시
    Future.microtask(() async {
      await showCustomFullScreenModal(
        context,
        TodoFirstDoneModal(),
      );
    });
  }
}
