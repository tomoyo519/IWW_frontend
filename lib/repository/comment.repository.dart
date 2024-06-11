import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iww_frontend/model/comment/comment.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';

class CommentRepository {
  Future<List<Comment>> fetchComments(String ownerId) async {
    // return dummy
    final url = '${Secrets.REMOTE_SERVER_URL}/guestbook/$ownerId/comment';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Comment> fetchedComments = data.map((commentData) {
          return Comment(
            comId: commentData['com_id'].toString(),
            authorId: commentData['author']['user_id'].toString(),
            authorName: commentData['author']['user_name'],
            content: commentData['content'],
            isMod: commentData['is_mod'],
          );
        }).toList();

        return fetchedComments;
      }
    } catch (e) {
      // 오류 처리
      return [];
    }
    return [];
  }

  Future<bool> addComment(
      String ownerId, String authorId, String content) async {
    final url = '${Secrets.REMOTE_SERVER_URL}/guestbook/$ownerId/comment';
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

  Future<bool> updateComment(
      String ownerId, String comId, String content) async {
    final url =
        '${Secrets.REMOTE_SERVER_URL}/guestbook/$ownerId/comment/$comId'; // 백엔드 URL

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

  Future<bool> deleteComment(String ownerId, String comId) async {
    final url =
        '${Secrets.REMOTE_SERVER_URL}/guestbook/$ownerId/comment/$comId'; // 백엔드 URL

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
}
