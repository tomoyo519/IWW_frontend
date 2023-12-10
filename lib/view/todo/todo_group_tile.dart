// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/utils/extension/string.ext.dart';
import 'package:iww_frontend/utils/extension/timeofday.ext.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/group/groupDetail.dart' as page;
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

// 출처: https://islet4you.tistory.com/entry/Flutter-Sound-재생하기 [hoony's web study:티스토리]
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
  late GroupTodoState todoState;
  late Group group;
  final _picker = ImagePicker();
  final scroll = ScrollController();

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
    UserInfo userInfo = context.read<UserInfo>();

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
          Expanded(
            flex: 8,
            child: GestureDetector(
              onTap: () {
                //  클릭하면 그룹 상세화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      // ==== 종속성 주입 ==== //
                      providers: [
                        ChangeNotifierProvider.value(
                            value: context.read<UserInfo>()),
                        ChangeNotifierProvider(
                          create: (_) => GroupDetailModel(
                              Provider.of<GroupRepository>(context,
                                  listen: false),
                              userInfo.userId),
                        )
                      ],
                      child: page.GroupDetail(
                        getList: null,
                        groupId: widget.todo.grpId!,
                        ownerName: userInfo.userName,
                      ),
                    ),
                  ),
                );
              },
              child: Column(
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
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.timer_outlined,
                          size: 15,
                        ),
                      ),
                      Text(
                        toViewDate(widget.todo.todoDate, null),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: MyButton(
              type: MyButtonType.primary,
              text: todoState == GroupTodoState.UNDONE
                  ? "인증하기"
                  : todoState == GroupTodoState.DONE
                      ? "인증 대기중"
                      : "✔ 인증 완료",
              onpressed: (context) async {
                _onGrpTodoCheck(context, widget.todo);

                final assetsAudioPlayer = AssetsAudioPlayer();

                assetsAudioPlayer.open(
                  Audio("assets/main.mp3"),
                );

                assetsAudioPlayer.play();
              },
              enabled: todoState == GroupTodoState.UNDONE,
            ),
          ),
        ],
      ),
    );
  }

  String toViewDate(String dateString, String? timeString) {
    String rtn = '';
    DateTime date = dateString.toDateTime()!;
    DateTime now = DateTime.now();

    if (date.day != now.day) {
      rtn += DateFormat('MM월 dd일 ').format(date);
    } else {
      rtn += '오늘 ';
    }

    if (timeString != null) {
      TimeOfDay time = timeString.toTimeOfDay()!;
      rtn += time.toViewString()!;
    }

    return rtn;
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
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: pickedFile.path);

      setState(() {
        _imageFile = rotatedImage;
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
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    '할일 완료!',
                    style: TextStyle(
                      // 여기에서 스타일을 적용합니다.
                      fontSize: 16, // 글자 크기
                      color: Colors.white, // 글자 색상
                      fontWeight: FontWeight.w500, // 글자 두께
                    ),
                  ),
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
        }
      }
    }
  }
}
