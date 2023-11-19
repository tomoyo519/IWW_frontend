import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:iww_frontend/screens/findContact.viewmodel.dart';
import 'package:provider/provider.dart';

class FindContact extends StatelessWidget {
  const FindContact({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<FindContactViewModel>();
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(style: TextStyle(fontSize: 15), "두윗에서 친구들을 찾아보세요!"),
                Expanded(child: _ContactList())
              ]),
        ),
      ),
    );
  }
}

class _ContactList extends StatelessWidget {
  const _ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FindContactViewModel>();
    final contacts = viewModel.contacts;
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, idx) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _ContactListTile(
                  name: contacts[idx].name ?? '',
                  nickName: contacts[idx].nickName,
                  profileImage: contacts[idx].profileImage),
            ));
  }
}

class _ContactListTile extends StatelessWidget {
  final String name;
  final String nickName;
  final String? profileImage;

  _ContactListTile(
      {Key? key, required this.name, required this.nickName, this.profileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FindContactViewModel>();

    onClickAddFriend(BuildContext context) async {
      // save friend
      log(viewModel.contacts.toString());
      await viewModel.addFriend();
    }

    return Row(
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
            onPressed: () => onClickAddFriend(context),
            icon: Icon(Icons.person_add_alt_1_rounded))
      ],
    );
  }
}
