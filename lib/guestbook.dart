import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'calendar.dart';
import 'listWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  String comId;
  String authorId;
  String userImage;
  String username;
  String content;
  bool isMod;

  Comment(
      {required this.comId,
      required this.authorId,
      required this.userImage,
      required this.username,
      required this.content,
      required this.isMod});
}

class CommentsProvider with ChangeNotifier {
  List<Comment> comments = [];

  void setComment(List<Comment> newComments) {
    comments = newComments;
    notifyListeners(); // 상태 변경 알림
  }
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

Future<void> fetchComments(
    CommentsProvider commentsProvider, String ownerId) async {
  final url = '/user/$ownerId/guestbook/comments';
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Comment> fetchedComments = data.map((commentData) {
        return Comment(
          comId: commentData['com_id'],
          authorId: commentData['author_id'],
          userImage: commentData['user_image'],
          username: commentData['user_name'],
          content: commentData['content'],
          isMod: commentData['is_mod'],
        );
      }).toList();

      commentsProvider.setComment(fetchedComments);
    }
  } catch (e) {
    // 오류 처리
  }
}

Future<bool> addComment(String ownerId, String authorId, String content) async {
  final url = 'yousayrun.store/user/$ownerId/guestbook/comments';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'owner_id': ownerId,
        'author_id': authorId,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    // 오류 처리
    return false;
  }
}

Future<bool> deleteComment(String ownerId, String comId) async {
  final url =
      'yousayrun.store/user/$ownerId/guestbook/comments/$comId'; // 백엔드 URL

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'com_id': comId,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 삭제된 경우
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
              child: ListView.builder(
                controller: scrollController,
                itemCount: commentsProvider.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = commentsProvider.comments[index];
                  bool isCurrentUserComment = comment.authorId == currentUserId;
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
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
                                  bool success = await deleteComment(
                                      ownerId, comment.comId);
                                  if (success) {
                                    // 삭제 성공 시, UI 업데이트
                                    fetchComments(commentsProvider, ownerId);
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
    TextEditingController _controller =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 수정'),
          content: TextField(
            controller: _controller,
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
              onPressed: _controller.text != comment.content
                  ? () async {
                      bool success = await updateComment(
                          ownerId, comment.comId, _controller.text);
                      if (success) {
                        fetchComments(commentsProvider, ownerId);
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
    TextEditingController _controller = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '댓글을 입력해주세요',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                String ownerID = ownerId; // 방명록 주인의 ID
                String currentUserID = authorId; // 현재 사용자 ID

                bool success =
                    await addComment(ownerID, currentUserID, _controller.text);
                if (success) {
                  fetchComments(commentsProvider, ownerID); // 댓글 목록을 새로고침
                }
                _controller.clear();
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
      'yousayrun.store/user/$ownerId/guestbook/comments/$comId'; // 백엔드 URL

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
