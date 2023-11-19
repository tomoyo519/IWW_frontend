import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calendar.dart';
import 'listWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  String userImage;
  String username;
  String content;
  num authorId;
  bool isModified;

  Comment(
      {required this.authorId,
      required this.userImage,
      required this.username,
      required this.content,
      required this.isModified});
}

class CommentsProvider with ChangeNotifier {
  List<Comment> comments = [];

  void addComment(Comment comment) {
    comments.add(comment);
    notifyListeners(); // 상태 변경 알림
  }
}

void showCommentsBottomSheet(
    BuildContext context, CommentsProvider commentsProvider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CommentsBottomSheet(commentsProvider: commentsProvider);
    },
  );
}

class CommentsBottomSheet extends StatelessWidget {
  final CommentsProvider commentsProvider;

  const CommentsBottomSheet({Key? key, required this.commentsProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(comment.userImage),
                    ),
                    title: Text(comment.username),
                    subtitle: Text(comment.content),
                    
                  );
                },
              ),
            ),
            CommentInputField(commentsProvider: commentsProvider),
          ],
        );
      },
    );
  }
}

class CommentInputField extends StatelessWidget {
  final CommentsProvider commentsProvider;

  CommentInputField({required this.commentsProvider});

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
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                commentsProvider.addComment(Comment(
                  userImage: 'https://example.com/default.jpg',
                  username: 'User',
                  content: _controller.text,
                  isModified: false,
                ));
                _controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
