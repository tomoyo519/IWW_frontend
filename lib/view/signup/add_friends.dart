import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/view/_common/profile_image.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/viewmodel/add_friends.viewmodel.dart';
import 'package:provider/provider.dart';

class AddFriendsPage extends StatelessWidget {
  const AddFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FindContactViewModel>(
      create: (_) => FindContactViewModel(
          Provider.of<UserRepository>(_, listen: false),
          Provider.of<FriendRepository>(_, listen: false)),
      child: AddFriends(),
    );
  }
}

// 연락처 기반 친구추가
class AddFriends extends StatelessWidget {
  const AddFriends({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FindContactViewModel>();

    return Scaffold(
      appBar: MyAppBar(title: Text("친구 찾아보기"), actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: Selector<FindContactViewModel, int>(
            selector: (_, model) => model.friendCnt,
            builder: (_, friendCnt, __) {
              return Text(viewModel.friendCnt > 0 ? "완료" : "건너뛰기");
            },
          ),
        )
      ]),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style: TextStyle(fontSize: 15),
                "두윗에서 친구들을 찾아보세요!",
              ),
              !viewModel.isFetched
                  ? Spinner()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.friends.length,
                        itemBuilder: (context, idx) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: _ContactListTile(
                            friendId: viewModel.friends[idx].user_id,
                            name: viewModel.friends[idx].user_name,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactListTile extends StatefulWidget {
  final int friendId;
  final String name;

  _ContactListTile({
    Key? key,
    required this.friendId,
    required this.name,
  }) : super(key: key);

  @override
  State<_ContactListTile> createState() => _ContactListTileState();
}

class _ContactListTileState extends State<_ContactListTile> {
  bool isAdded = false;

  Future<void> _onClickAddFriend(BuildContext context) async {
    final viewModel = context.read<FindContactViewModel>();
    if (isAdded == false) {
      // 기존 친구가 아닌 경우 추가
      if (await viewModel.createFriend(widget.friendId)) {
        setState(() {
          isAdded = true;
          // viewModel.friendCnt++;
        });
      }
    } else {
      // 친구로 추가되었던 경우 삭제
      if (await viewModel.deleteFriend(widget.friendId)) {
        setState(() {
          isAdded = false;
          // viewModel.friendCnt--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          // 데이터 부분
          children: [
            ProfileImage(
              width: 40,
              height: 40,
              userId: widget.friendId,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    widget.name),
                SizedBox(
                  width: 10,
                ),
                const Text(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    "연락처 기반 추천")
              ],
            )
          ],
        ),
        Ink(
          decoration: BoxDecoration(
            color: isAdded ? Colors.blue.shade900 : Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              iconSize: 20,
              color: isAdded ? Colors.white : Colors.black87,
              onPressed: () => _onClickAddFriend(context),
              icon:
                  Icon(isAdded ? Icons.check : Icons.person_add_alt_1_rounded)),
        )
      ],
    );
  }
}
