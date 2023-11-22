import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/model/comment/comment.model.dart';
import 'dart:convert';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:provider/provider.dart';

// 방명록 상태관리
class CommentsProvider with ChangeNotifier {
  final AuthService _authService;
  final RoomRepository _roomRepository;
  final CommentRepository _commentRepository;

  // 방을 클릭할때마다 유지되는 상태
  final _roomOwnerId = "1";
  String get roomOwnerId => _roomOwnerId;

  CommentsProvider(
    this._authService,
    this._roomRepository,
    this._commentRepository,
  );

  List<Comment> comments = [];

  // 댓글 데이터 불러오기
  Future<void> fetchComment(String ownerId) async {
    comments = await _commentRepository.fetchComments(ownerId);
    notifyListeners(); // 상태 변경 알림
  }

  // 댓글 생성
  Future<bool> addComment(
      String ownerId, String authorId, String content) async {
    return await _commentRepository.addComment(ownerId, authorId, content);
  }

  // 댓글 수정
  Future<bool> updateComment(
      String ownerId, String authorId, String content) async {
    return await _commentRepository.updateComment(ownerId, authorId, content);
  }

  // 댓글 삭제
  Future<bool> deleteComment(String ownerId, String comId) async {
    return await _commentRepository.deleteComment(ownerId, comId);
  }

  // 현재 유저 정보 반환
  Future<int?> getUserId() async {
    return await _authService.getCurrentUser().then((user) => user?.user_id);
  }
}

// 방명록 bottom sheet 트리거
void showCommentsBottomSheet(BuildContext context,
    CommentsProvider commentsProvider, userId, ownerId) async {
  // 댓글 데이터 가져오기
  await commentsProvider.fetchComment(ownerId);

  if (context.mounted) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommentsBottomSheet(
            commentsProvider: commentsProvider,
            userId: userId,
            ownerId: ownerId,
          );
        });
  }
}

// 방명록 bottom sheet 뷰
class CommentsBottomSheet extends StatelessWidget {
  final CommentsProvider commentsProvider;
  final String ownerId;
  final String userId;

  const CommentsBottomSheet({
    Key? key,
    required this.commentsProvider,
    required this.ownerId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOwner = ownerId == userId;
    final comments = commentsProvider.comments;

    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = comments[index];
                  bool isCurrentUserComment = (comment.authorId == userId);
                  // return isCurrentUserComment
                  //   ? _buildDismissibleComment(comment, context)
                  //   : _buildListTile(comment);
                  return ListTile (
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(comment.userImage),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: Image.network(comment.userImage, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage("assets/profile.jpg"),
                          );
                        },
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(comment.username),
                        if (comment.isMod)
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "(수정됨)",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                                      .deleteComment(ownerId, comment.comId);
                                  if (success) {
                                    // 삭제 성공 시, UI 업데이트
                                    commentsProvider.fetchComment(ownerId);
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
            )),
            if (!isOwner)
              CommentInputField(
                  commentsProvider: commentsProvider,
                  ownerId: ownerId,
                  authorId: userId),
          ],
        );
      },
    );
  }

  // Widget _buildDismissibleComment(Comment comment, BuildContext context) {
  //   return Dismissible(
  //     key: Key(comment.comId),
  //     direction: DismissDirection.endToStart,
  //     background: Container(
  //       color: Colors.transparent,
  //     ),
  //     secondaryBackground: Container(
  //       color: Colors.red,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           _buildActionButton(Icons.edit, Colors.green, () {
  //             _showEditCommentDialog(context, comment, commentsProvider);
  //           }),
  //           _buildActionButton(Icons.delete, Colors.red, () async {
  //             bool success = await commentsProvider.deleteComment(ownerId, comment.comId);
  //             if (success) {
  //               commentsProvider.fetchComment(ownerId);
  //             }
  //           }),
  //         ],
  //       ),
  //     ),
  //     onDismissed: (direction) {
  //       // 슬라이드 방향에 따른 액션 추가
  //     },
  //     child: _buildListTile(comment),
  //   );
  // }

  // Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
  //   return Container(
  //     color: color,
  //     child: IconButton(
  //       icon: Icon(icon, color: Colors.white),
  //       onPressed: onPressed,
  //     ),
  //   );
  // }

  // Widget _buildListTile(Comment comment) {
  //   return ListTile(
  //     leading: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
  //       child: CircleAvatar(
  //         radius: 20,
  //         backgroundImage: NetworkImage(comment.userImage),
  //         onBackgroundImageError: (exception, stackTrace) {},
  //         child: Image.network(
  //           comment.userImage,
  //           fit: BoxFit.cover,
  //           errorBuilder: (context, error, stackTrace) {
  //             return CircleAvatar(
  //               radius: 20,
  //               backgroundImage: AssetImage("assets/profile.jpg"),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //     title: Row(
  //       children: [
  //         Text(comment.username),
  //         if (comment.isMod)
  //           Padding(
  //             padding: EdgeInsets.only(left: 8),
  //             child: Text(
  //               "(수정됨)",
  //               style: TextStyle(fontSize: 12, color: Colors.grey),
  //             ),
  //           ),
  //       ],
  //     ),
  //     subtitle: Text(comment.content),
  //     // trailing: isCurrentUserComment
  //     //     ? Row(
  //     //         mainAxisSize: MainAxisSize.min,
  //     //         children: [
  //     //           IconButton(
  //     //             icon: Icon(Icons.edit),
  //     //             onPressed: () {
  //     //               _showEditCommentDialog(
  //     //                   context, comment, commentsProvider);
  //     //             },
  //     //           ),
  //     //           IconButton(
  //     //             icon: Icon(Icons.delete),
  //     //             onPressed: () async {
  //     //               bool success = await commentsProvider
  //     //                   .deleteComment(ownerId, comment.comId);
  //     //               if (success) {
  //     //                 // 삭제 성공 시, UI 업데이트
  //     //                 commentsProvider.fetchComment(ownerId);
  //     //               } else {
  //     //                 // 삭제 실패 시, 사용자에게 알림
  //     //               }
  //     //             },
  //     //           ),
  //     //         ],
  //     //       )
  //     //     : SizedBox.shrink(),
  //   );
  // }

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
                      bool success = await commentsProvider.updateComment(
                          ownerId, comment.comId, controller.text);
                      if (success) {
                        // 댓글 새로고침
                        commentsProvider.fetchComment(ownerId);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
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

                bool success = await commentsProvider.addComment(
                    ownerID, currentUserID, controller.text);
                if (success) {
                  // 댓글 새로고침
                  commentsProvider.fetchComment(ownerId);
                }
                controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
