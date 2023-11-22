import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/view/widget/groupDetail.dart';
import 'newGroup.dart';

class FriendList extends StatefulWidget {
  final FriendRepository friendRepository;

  const FriendList({super.key, required this.friendRepository});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<UserInfo> friends = [];

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    List<UserInfo> fetchedFriends = await widget.friendRepository.getFriends();
    setState(() {
      friends = fetchedFriends;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                  ),
                  title: Text(friends[i].user_name),
                );
              }))
    ]);
  }
}
