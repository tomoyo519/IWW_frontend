import 'package:flutter/material.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/style/textfield.dart';
import 'package:iww_frontend/viewmodel/signup.viewmodel.dart';
import 'package:provider/provider.dart';

class NamePage extends StatelessWidget {
  const NamePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    // Future.microtask(() {
    //   showCustomFullScreenModal(
    //     context,
    //     SignUpModal(screen: screen),
    //   );
    // });

    final viewmodel = context.read<SignUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MyTextField(
          label: "닉네임",
          onchange: (value) {
            viewmodel.name = value;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(
            viewmodel.userNameError,
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
            ),
          ),
        ),
        MyButton(
          text: "다음",
          type: MyButtonType.primary,
          onpressed: (context) {
            viewmodel.validateName();
          },
        )
      ],
    );
  }
}
