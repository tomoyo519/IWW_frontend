import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

class LoginWrapper extends StatelessWidget {
  final Widget child;
  LoginWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool waiting = context.read<AuthService>().waiting;
    final UserModel? user = context.read<AuthService>().user;

    return waiting
        ? Placeholder()
        : (user == null)
            ? LandingPage()
            : ChangeNotifierProvider.value(
                value: context.read<UserInfo>(), child: child);
  }
}
