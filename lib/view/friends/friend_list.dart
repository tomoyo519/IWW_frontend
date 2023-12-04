import 'package:flutter/material.dart';
import 'package:iww_frontend/model/friend/friend.model.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {
  final int userId;

  const FriendList({Key? key, required this.userId}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<FriendInfo> friends = [];
  late int _userId; // 나의 id
  final FriendRepository friendRepository = FriendRepository();

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    List<FriendInfo> fetchedFriends =
        await friendRepository.getFriends(_userId);
    setState(() {
      friends = fetchedFriends;
    });
  }

  @override
  Widget build(BuildContext context) {
    LOG.log('전달받은 friend수: ${friends.length}');

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            FriendInfo user = friends[index];

            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, user.userId);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/kingfisher.png'), // TODO 사용자 펫의 이미지로 수정
                  ),
                  title: Text(user.userName),
                  subtitle: Text('${user.petName}, 총 경험치  : ${user.totalExp}'),
                ),
              ),
            );
          },
        ))
      ],
    );
  }
}
