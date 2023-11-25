import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/profile_image.dart';
import 'package:provider/provider.dart';

class HomeProfile extends StatelessWidget {
  final UserInfo user;
  const HomeProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ProfileImage(
                  width: 70,
                  height: 70,
                  userId: user.user_id,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.user_name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(),
                        child: Text("Today  4/5"),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(),
                        child: Text("Total  4/5"),
                      ),
                      TextButton(
                        onPressed: () {
                          authService.logout().then((value) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/app", (route) => false);
                          });
                        },
                        style: TextButton.styleFrom(),
                        child: Text("로그아웃"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
