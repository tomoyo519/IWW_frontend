import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void showTodoConfirmModal(BuildContext context, String? message) {
  if (message == null) return;
  final UserInfo user = Provider.of<UserInfo>(context, listen: false);
  final TodoRepository todoRepository =
      Provider.of<TodoRepository>(context, listen: false);

  // message에서 필요한 데이터 파싱
  Map<String, dynamic> data = jsonDecode(message);
  String todoImg = data['todoImg'];
  int senderId = data['senderId'];
  String senderName = data['senderName'];
  int todoId = data['todoId'];
  String todoName = data['todoName'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return AlertDialog(
      //   title: Text('그룹 할일 인증'),
      //   content: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           // 사진 전체 화면으로 확대
      //           Navigator.of(context).push(MaterialPageRoute(
      //             builder: (_) => FullScreenImage(
      //                 '${Secrets.REMOTE_SERVER_URL}/group-image/' + todoImg),
      //           ));
      //         },
      //         child: Image.network(
      //             '${Secrets.REMOTE_SERVER_URL}/group-image/' + todoImg,
      //             fit: BoxFit.cover),
      //       ),
      //       SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Expanded(child: Text(todoName)),
      //           Text(senderName),
      //         ],
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     TextButton(
      //       onPressed: () => Navigator.of(context).pop(),
      //       child: Text('취소'),
      //     ),
      //     TextButton(
      //       onPressed: () async {
      //         // TODO: todo 업데이트 로직 및 socket.emit 구현
      //         bool result =
      //             await todoRepository.confirmGroupTodo(todoId.toString());

      //         if (result) {
      //           var data = {'userId': user.userId, 'todoId': todoId};
      //           EventService.sendEvent('confirmResponse', data);
      //         }
      //         Navigator.of(context).pop();
      //       },
      //       child: Text('인증 완료'),
      //     ),
      //   ],
      // );
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        // titlePadding: EdgeInsets.all(0),
        // title: Container(
        //   decoration: BoxDecoration(
        //       color: Color.fromARGB(255, 254, 204, 129),
        //       borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        //   padding: EdgeInsets.all(10),
        //   child: Text(
        //     '그룹 할일 인증',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        title: Text(
          '그룹 할일 확인',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                // 사진 전체 화면으로 확대
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FullScreenImage(
                      '${Secrets.REMOTE_SERVER_URL}/group-image/' + todoImg),
                ));
                final assetsAudioPlayer = AssetsAudioPlayer();
                assetsAudioPlayer.open(Audio("assets/main.mp3"));
                assetsAudioPlayer.play();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // 모서리 반경 설정
                child: Image.network(
                  '${Secrets.REMOTE_SERVER_URL}/group-image/' + todoImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "$senderName님의 \"$todoName\"에 대한 사진입니다. 확인해주시겠습니까?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final assetsAudioPlayer = AssetsAudioPlayer();

              assetsAudioPlayer.open(
                Audio("assets/main.mp3"),
              );

              assetsAudioPlayer.play();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[350],
              foregroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                // 모서리 둥글기 조절
                borderRadius: BorderRadius.circular(8), // 모서리 반경 조절
              ),
            ),
            child: Text('취소',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              // TODO: todo 업데이트 로직 및 socket.emit 구현
              bool result =
                  await todoRepository.confirmGroupTodo(todoId.toString());

              LOG.log('$result');
              if (result) {
                var data = {'userId': user.userId, 'todoId': todoId};
                EventService.sendEvent('confirmResponse', data);
              }
              final assetsAudioPlayer = AssetsAudioPlayer();
              assetsAudioPlayer.open(Audio("assets/main.mp3"));
              assetsAudioPlayer.play();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              // backgroundColor: Color.fromARGB(255, 254, 204, 129),
              // foregroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                // 모서리 둥글기 조절
                borderRadius: BorderRadius.circular(8), // 모서리 반경 조절
              ),
            ),
            child: Text(
              '확인 완료',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
