import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/model/comment/comment.model.dart';
import 'dart:convert';

import 'package:iww_frontend/service/auth.service.dart';

class CommentsProvider with ChangeNotifier {
  final AuthService _authService;
  final RoomRepository _roomRepository;
  final CommentRepository _commentRepository;

  // 방을 클릭할때마다 유지되는 상태
  String _roomOwnerId = "1";
  String get roomOwnerId => _roomOwnerId;

  CommentsProvider(
      this._authService, this._roomRepository, this._commentRepository);

  // 댓글 목록 반환
  Future<List<Comment>> get comments async {
    return _commentRepository.fetchComments(roomOwnerId);
  }

  // 댓글 목록 새로고침
  void setComment(List<Comment> newComments) {
    // comments = newComments;
    notifyListeners(); // 상태 변경 알림
  }

  void refresh() {
    notifyListeners();
  }

  // 댓글 생성
  Future<bool> addComment(
      String ownerId, String authorId, String content) async {
    return await _commentRepository.addComment(ownerId, authorId, content);
  }

  // 댓글 삭제
  Future<bool> deleteComment(String ownerId, String comId) async {
    return await _commentRepository.deleteComment(ownerId, comId);
  }

  // 현재 유저 정보 반환
  Future<int?> getUserId() async {
    return await _authService.getCurrentUser().then((user) => user?.user_id);
  }

  // 특정 유저 룸 정보 반환
  // Future<String?> getRoomOwnerId(int userId) async {
  //   return await _roomRepository.getRoom(userId).then((room) => room?.owner_id);
  // }

  // Future<List<Comment>> getComments() async {
  //   return _commentRepository.getAllComments();
  // }
}

void showCommentsBottomSheet(BuildContext context,
    CommentsProvider commentsProvider, String currentUserID, ownerId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CommentsBottomSheet(
        commentsProvider: commentsProvider,
        ownerId: ownerId,
        currentUserId: currentUserID,
      );
    },
  );
}

class CommentsBottomSheet extends StatelessWidget {
  final CommentsProvider commentsProvider;
  final String ownerId;
  final String currentUserId;

  const CommentsBottomSheet({
    Key? key,
    required this.commentsProvider,
    required this.ownerId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOwner = ownerId == currentUserId;
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: commentsProvider.comments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<Comment> comments = snapshot.data!;
                    // 데이터 로드 완료
                    return Expanded(
                        child: ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = comments[index];
                        bool isCurrentUserComment =
                            comment.authorId == currentUserId;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment.userImage),
                          ),
                          title: Row(
                            children: [
                              Text(comment.username),
                              if (comment.isMod)
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "(수정됨)",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(comment.content),
                          trailing: isCurrentUserComment
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditCommentDialog(
                                            context, comment, commentsProvider);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        bool success = await commentsProvider
                                            .deleteComment(
                                                ownerId, comment.comId);
                                        if (success) {
                                          // 삭제 성공 시, UI 업데이트
                                          commentsProvider.refresh();
                                          // fetchComments(
                                          //     commentsProvider, ownerId);
                                        } else {
                                          // 삭제 실패 시, 사용자에게 알림
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        );
                      },
                    ));
                  } else {
                    return Text("No Data!");
                  }
                },
              ),
            ),
            if (!isOwner)
              CommentInputField(
                  commentsProvider: commentsProvider,
                  ownerId: ownerId,
                  authorId: currentUserId),
          ],
        );
      },
    );
  }

  void _showEditCommentDialog(BuildContext context, Comment comment,
      CommentsProvider commentsProvider) {
    TextEditingController controller =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 수정'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "댓글을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: controller.text != comment.content
                  ? () async {
                      bool success = await updateComment(
                          ownerId, comment.comId, controller.text);
                      if (success) {
                        // fetchComments(commentsProvider, ownerId);
                        commentsProvider.refresh();
                      }
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }
}

class CommentInputField extends StatelessWidget {
  final CommentsProvider commentsProvider;
  final String ownerId;
  final String authorId;

  CommentInputField(
      {Key? key,
      required this.commentsProvider,
      required this.ownerId,
      required this.authorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: '댓글을 입력해주세요',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                String ownerID = ownerId; // 방명록 주인의 ID
                String currentUserID = authorId; // 현재 사용자 ID

                // bool success =
                //     await addComment(ownerID, currentUserID, controller.text);
                // if (success) {
                //   fetchComments(commentsProvider, ownerID); // 댓글 목록을 새로고침
                // }
                controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<bool> updateComment(String ownerId, String comId, String content) async {
  final url =
      '${Secrets.TEST_SERVER_URL}/user/$ownerId/guestbook/comments/$comId'; // 백엔드 URL

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 업데이트된 경우
      return true;
    } else {
      // 실패 처리
      return false;
    }
  } catch (e) {
    // 오류 처리
    return false;
  }
}
