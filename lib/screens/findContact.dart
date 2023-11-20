import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:iww_frontend/screens/findContact.viewmodel.dart';
import 'package:provider/provider.dart';

// class AddFriends extends StatefulWidget {
//   const AddFriends({super.key});

//   @override
//   State<AddFriends> createState() => _AddFriendsState();
// }

// class _AddFriendsState extends State<AddFriends> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   void _checkContactAvailable() async {
//     final viewModel = context.read<FindContactViewModel>();
//     bool isAvailable = (await viewModel.isNetworkConnected &&
//         await viewModel.isContactGranted);

//     if (isAvailable) {
//       // 연락처 조회가 가능한 경우
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => _AddFriends()),
//       );
//     } else {
//       Navigator.pushNamed(context, "/home");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

class AddFriends extends StatelessWidget {
  const AddFriends({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindContactViewModel>();

    return Scaffold(
      appBar: MyAppBar(title: Text("친구 찾아보기"), actions: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Text("건너뛰기"))
      ]),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(style: TextStyle(fontSize: 15), "두윗에서 친구들을 찾아보세요!"),
            FutureBuilder(
                future: viewModel.contacts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    // 데이터 로드 완료
                    List<Contact> contacts = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, idx) =>
                          // Text(contacts[idx].displayName ?? 'name')
                          _ContactListTile(
                        name: contacts[idx].displayName ?? '',
                        nickName: contacts[idx].displayName!,
                        profileImage: null,
                      ),
                    ));
                  } else {
                    // Navigator.pushNamed(context, "/home");
                    return Text("연락처 데이터 없음");
                  }
                })
          ]),
        ),
      ),
    );
  }
}

class _ContactListTile extends StatelessWidget {
  final String name;
  final String nickName;
  final String? profileImage;

  _ContactListTile(
      {Key? key, required this.name, required this.nickName, this.profileImage})
      : super(key: key);

  _onClickAddFriend(BuildContext context) async {
    final viewModel = context.read<FindContactViewModel>();
    // save friend
    log(viewModel.contacts.toString());
    await viewModel.addFriend();
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
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(profileImage ?? "assets/profile.jpg"),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    nickName),
                SizedBox(
                  width: 10,
                ),
                Text(style: TextStyle(color: Colors.grey, fontSize: 12), name)
              ],
            )
          ],
        ),
        IconButton(
            iconSize: 20,
            style: ElevatedButton.styleFrom(),
            onPressed: () => _onClickAddFriend(context),
            icon: Icon(Icons.person_add_alt_1_rounded))
      ],
    );
  }
}
