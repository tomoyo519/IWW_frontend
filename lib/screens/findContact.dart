import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/screens/findContact.viewmodel.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:provider/provider.dart';

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
                    List<UserInfo> contacts = snapshot.data!;

                    return Expanded(
                        child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, idx) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: _ContactListTile(
                          name: contacts[idx].user_name,
                          profileImage:
                              "${Secrets.TEST_SERVER_URL}/image/${contacts[idx].user_kakao_id}.jpg",
                        ),
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
  final String? profileImage;

  _ContactListTile({Key? key, required this.name, this.profileImage})
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
              width: 40,
              height: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/profile.jpg");
                    },
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    name),
                SizedBox(
                  width: 10,
                ),
                const Text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    "연락처 기반 추천")
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
