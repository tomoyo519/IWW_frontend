import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';
import 'package:provider/provider.dart';

class LoginWrapper extends StatelessWidget {
  final Widget child;
  LoginWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool waiting = context.watch<AuthService>().waiting;
    final UserInfo? user = context.watch<AuthService>().user;

    return waiting
        ? Placeholder()
        : (user == null)
            ? LandingPage()
            : Provider<UserInfo>.value(
                value: user,
                child: ChangeNotifierProvider<UserProvider>(
                  create: (context) => UserProvider(
                      Provider.of<UserRepository>(context, listen: false),
                      user),
                  child: child,
                ));
  }
}
