// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

// Todo Extension으로 스타일 만들기
enum GroupTodoState {
  DONE,
  UNDONE,
  APPROVED,
}

class GroupTodoTile extends StatefulWidget {
  final Todo todo;
  final TodoViewModel viewmodel;

  static final List<List<Color>> gradients = [
    [Color(0xffff0f7b), Color(0xfff89b29)],
  ];

  const GroupTodoTile({
    super.key,
    required this.todo,
    required this.viewmodel,
  });

  @override
  State<GroupTodoTile> createState() => _GroupTodoTileState();
}

class _GroupTodoTileState extends State<GroupTodoTile> {
  late File _imageFile;

  final _picker = ImagePicker();
  final scroll = ScrollController();

  late GroupTodoState todoState;

  @override
  void initState() {
    super.initState();
    // 그룹 투두의 상태 초기화
    if (widget.todo.todoDone) {
      // 1. 다른 사용자에 의해 승인되었습니다.
      todoState = GroupTodoState.APPROVED;
    } else if (widget.todo.todoImg != null) {
      // 2. 인증 사진이 첨부되어 승인 대기중입니다.
      todoState = GroupTodoState.DONE;
    } else {
      // 3. 아직 인증이 완료되지 않았습니다.
      todoState = GroupTodoState.UNDONE;
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
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 246, 246, 246),
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
                  decoration: todoState == GroupTodoState.APPROVED
                      ? TextDecoration.lineThrough // 완료된 경우
                      : TextDecoration.none, // 아직 미완
                  color: todoState == GroupTodoState.APPROVED
                      ? Colors.black45
                      : Colors.black87,
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

            // * ===== 버튼 클릭시 투두 체크 ===== * //
            onPressed: todoState == GroupTodoState.UNDONE
                ? () => _onGrpTodoCheck(context, widget.todo)
                : null,
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
                  // * ==== 투두 상태 ==== * //
                  todoState == GroupTodoState.UNDONE
                      ? "인증하기"
                      : todoState == GroupTodoState.DONE
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

  Future<void> _onGrpTodoCheck(BuildContext context, Todo todo) async {
    // // 이미 체크 완료 되어있는 todo 의 체크를 해제하는 경우.
    // if (todo.todoDone && todo.grpId != null) {
    //   if (mounted) {
    //     showCustomAlertDialog(
    //       context: context,
    //       content: Text("완료처리가 되어있는 할일이에요.\n할일 체크를 해제하시겠어요?"),
    //       actions: [
    //         Row(
    //           children: [
    //             TextButton(
    //               child: Text('할일 체크를 해제할래요.'),
    //               onPressed: () async {
    //                 final viewModel = context.read<TodoViewModel>();
    //                 final result = await viewModel.checkGroupTodo(
    //                     widget.todo.todoId, false,
    //                     userId: widget.todo.userId, path: "");
    //                 if (context.mounted) {
    //                   Navigator.pop(context);
    //                   if (result == true) {
    //                     // _handleTodoCashReward(
    //                     //     context: context, value: false);
    //                   }
    //                 }
    //               },
    //             ),
    //             TextButton(
    //               child: Text('취소'),
    //               onPressed: () async {
    //                 Navigator.pop(context);
    //               },
    //             ),
    //           ],
    //         )
    //       ],
    //     );
    //   }
    // }

    // 체크가 되어있지 않은 todo를 사진전송 하고 완료 처리 하는 경우,
    final pickedFile = await _picker
        .pickImage(source: ImageSource.camera)
        .onError((error, stackTrace) {
      // 사용자가 권한거부하여 picker 창이 종료된 경우
      LOG.log("Error while opening image picker! $error");
      return null;
    });

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        LOG.log("image file ${_imageFile.toString()}");
      });
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(DateTime.now());

      if (context.mounted) {
        // * ==== 사진 확인 및 할일 완료 모달 ==== * //
        bool? saved = await showGeneralDialog(
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
                    // * ==== 버튼 눌렀을때의 로직 ==== * //
                    final viewModel = context.read<TodoViewModel>();
                    final result = await viewModel.checkGroupTodo(
                        widget.todo.todoId,
                        widget.todo.userId,
                        pickedFile.path);

                    LOG.log("사진인증 $result");
                    // if (result != null && context.mounted) {
                    //   _handleTodoCashReward(context: context, value: true);
                    //   var data = {
                    //     'userId': widget.todo.userId,
                    //     'todoId': widget.todo.todoId,
                    //     'photoUrl': pickedFile.path,
                    //   };

                    //   EventService.sendEvent('confirmRequest', data);

                    //   Navigator.pop(context);
                    // }
                    var data = {
                      'userId': widget.todo.userId,
                      'todoId': widget.todo.todoId,
                    };
                    EventService.sendEvent('confirmRequest', data);
                    if (context.mounted) {
                      Navigator.pop(context, true);
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
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 300),
        );

        // * ===== 인증 완료 후 리프레시 ===== * //
        if (saved != null && saved == true && context.mounted) {
          LOG.log('message');
          context.read<TodoViewModel>().fetchTodos();
          EventService.publish(Event(
            type: EventType.onTodoApproved,
            message: "인증을 완료했어요!",
          ));
        }
      }
    }
  }

  // 그룹 투두를 체크한 경우
  // Future<void> _groupTodoCheck(
  //   BuildContext context,
  //   XFile pickedFile,
  //   String formattedDate,
  // ) {
  //   return
  // }

  // // ****************************** //
  // // *                            * //
  // // *        Cash Reward         * //
  // // *                            * //
  // // ****************************** //

  // // 리워드 지급
  // void _handleTodoCashReward({
  //   required BuildContext context,
  //   required bool value,
  // }) {
  //   final usermodel = context.read<UserProvider>();
  //   final todomodel = context.read<TodoViewModel>();

  //   if (value == true) {
  //     // 펫 경험치 업데이트
  //     usermodel.petExp += 10;

  //     // 유저 Hp 업데이트

  //     var cash = todomodel.isTodaysFirstTodo ? 100 : 25;
  //     usermodel.userCash += cash;

  //     // UI
  //     if (todomodel.notifyUser) {
  //       _showFirstTodoDoneModal(context);
  //       todomodel.notifyUser = false;
  //       return;
  //     }
  //     _showCheckSnackBar(context, "할일이 완료되었어요! +$cash");
  //   } else {
  //     // 펫 경험치 업데이트

  //     // 유저 Hp 업데이트

  //     // 오늘의 마지막 투두이면
  //     var cash = todomodel.getTodaysChecked(DateTime.now()) == 1 ? 100 : 25;
  //     usermodel.userCash -= cash;

  //     _showCheckSnackBar(context, "할일을 취소했어요 -$cash");
  //   }
  // }

  // // 스낵바를 보여줍니다
  // void _showCheckSnackBar(BuildContext context, String message) {
  //   showCustomSnackBar(
  //     context,
  //     text: message,
  //     icon: Lottie.asset(
  //       "assets/star.json",
  //       animate: true,
  //     ),
  //   );
  // }

  // // * 첫 투두 완료 모달 *//
  // Future<void> _showFirstTodoDoneModal(BuildContext context) async {
  //   // 위젯 빌드 후에 모달 표시
  //   Future.microtask(() async {
  //     await showCustomFullScreenModal(
  //       context,
  //       TodoFirstDoneModal(),
  //     );
  //   });
  // }
}

class CutomAlertDialog extends StatelessWidget {
  const CutomAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
