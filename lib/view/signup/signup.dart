import 'package:flutter/material.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/signup/subpages/name.dart';
import 'package:iww_frontend/view/signup/subpages/pet.dart';
import 'package:iww_frontend/view/signup/subpages/tel.dart';
import 'package:iww_frontend/viewmodel/signup.viewmodel.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider<SignUpViewModel>(
      create: (_) => SignUpViewModel(authService),
      child: SignUp(),
    );
  }
}

/// 회원가입
class SignUp extends StatelessWidget {
  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<SignUpViewModel>();

    Widget? body;
    switch (viewmodel.pageIdx) {
      case 0:
        body = NamePage();
        break;
      case 1:
        body = TelPage();
        break;
      case 2:
        body = PetPage();
        break;
      case 3:
        // body = ();
        break;
      default:
        body = NamePage();
        break;
    }

    return Scaffold(
      appBar: MyAppBar(title: const Text("회원가입")),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: body,
        ),
      ),
    );
  }
}
