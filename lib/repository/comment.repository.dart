import 'package:iww_frontend/model/comment/comment.model.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/model/comment/comment.model.dart';
import 'dart:convert';
import 'package:iww_frontend/service/auth.service.dart';

class CommentRepository {
  List<Comment> dummy = [
    Comment(
        authorId: '2',
        comId: '1',
        username: "피카츄",
        content: "댓글1",
        isMod: false),
    Comment(
        authorId: '3',
        comId: '2',
        username: "라이츄",
        content: "댓글2",
        isMod: true),
    Comment(
        authorId: '6',
        comId: '3',
        username: "파이리",
        content: "댓글3",
        isMod: false),
    Comment(
        authorId: '4',
        comId: '4',
        username: "꼬부기",
        content: "댓글4",
        isMod: false),
  ];

  Future<List<Comment>> fetchComments(String ownerId) async {
    return dummy;
    // final url = '${Secrets.TEST_SERVER_URL}/user/$ownerId/guestbook/comments';
    // try {
    //   final response = await http.get(Uri.parse(url));

    //   if (response.statusCode == 200) {
    //     List<dynamic> data = jsonDecode(response.body);
    //     List<Comment> fetchedComments = data.map((commentData) {
    //       return Comment(
    //         comId: commentData['com_id'],
    //         authorId: commentData['author_id'],
    //         username: commentData['user_name'],
    //         content: commentData['content'],
    //         isMod: commentData['is_mod'],
    //       );
    //     }).toList();

    //     commentsProvider.setComment(fetchedComments);
    //   }
    // } catch (e) {
    //   // 오류 처리
    // }
  }

  Future<bool> addComment(
      String ownerId, String authorId, String content) async {
    final url = '${Secrets.TEST_SERVER_URL}/user/$ownerId/guestbook/comments';
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

  Future<bool> deleteComment(String ownerId, String comId) async {
    final url =
        '${Secrets.TEST_SERVER_URL}/user/$ownerId/guestbook/comments/$comId'; // 백엔드 URL

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
