import 'package:flutter/material.dart';

class UserPet {
  int userId;
  String userName;
  String petName;
  int petLv;
  Image petImage;

  UserPet({
    required this.userId,
    required this.userName,
    required this.petName,
    required this.petLv,
    required this.petImage,
  });
}


class FriendRank extends StatelessWidget {
  FriendRank({super.key});

  final List<UserPet> dummy = [
    UserPet(
      userId: 1,
      userName: '신병철',
      petName: '도구리',
      petLv: 30,
      petImage: Image.asset('assets/kitsune.png'),
    ),
    UserPet(
      userId: 3,
      userName: '이인복',
      petName: '샴쌍둥이',
      petLv: 25,
      petImage: Image.asset('assets/cerberus.png'),
    ),
    UserPet(
      userId: 2,
      userName: '정다희',
      petName: '용이될상인가',
      petLv: 14,
      petImage: Image.asset('assets/iguana.png'),
    ),
    UserPet(
      userId: 5,
      userName: '이소정',
      petName: '페르마의 Sojeong Lee',
      petLv: 7,
      petImage: Image.asset('assets/kingfisher.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: dummy.length,
            itemBuilder: (context, index) {
              final userPet = dummy[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    if (index == 0) { // 1위에 해당하는 아이템을 클릭했을 때
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/myroom",
                        arguments: false, // 여기에 적절한 조건을 설정하세요
                        (route) => false,
                      );
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userPet.petImage.image,
                    ),
                    title: Text(userPet.userName),
                    subtitle: Text('${userPet.petName}, Level: ${userPet.petLv}'),
                  ),
                ),
              );
            },
          )
        )
      ],
    );
  }
}
