import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/friend.repository.dart';

class FriendList extends StatefulWidget {
  final int userId;

  const FriendList({Key? key, required this.userId}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<UserModel> friends = [];
  late int _userId = -1; // 나의 id
  final FriendRepository friendRepository = FriendRepository();

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    List<UserModel> fetchedFriends = await friendRepository.getFriends();
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
