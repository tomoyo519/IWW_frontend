import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/friend/friend.model.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
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
    AppNavigator nav = context.read<AppNavigator>();

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            FriendInfo friend = friends[index];

            return Card(
              child: InkWell(
                onTap: () async {
                  // 사용자 화면으로 이동해야 합니다.
                  final assetsAudioPlayer = AssetsAudioPlayer();
                  assetsAudioPlayer.open(Audio("assets/main.mp3"));
                  assetsAudioPlayer.play();
                  nav.navigate(
                    AppRoute.room,
                    argument: friend.userId.toString(),
                  );
                  // Navigator.pop(context);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/kingfisher.png'), // TODO 사용자 펫의 이미지로 수정
                  ),
                  title: Text(friend.userName),
                  subtitle:
                      Text('${friend.petName}, 총 경험치  : ${friend.totalExp}'),
                ),
              ),
            );
          },
        ))
      ],
    );
  }
}
