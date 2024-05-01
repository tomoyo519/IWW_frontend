import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/style/textfield.dart';
import 'package:iww_frontend/viewmodel/signup.viewmodel.dart';
import 'package:provider/provider.dart';

class TelPage extends StatefulWidget {
  const TelPage({super.key});

  @override
  State<TelPage> createState() => _TelPageState();
}

class _TelPageState extends State<TelPage> {
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();

    _sub = EventService.stream.listen((event) {
      if (event.type == EventType.onSnsAuth) {
        Future.microtask(() {
          event.type.run(context);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<SignUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * ==== 연락처 입력 필드 ==== * //
        Flexible(
          flex: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      label: "연락처",
                      onchange: (value) {
                        viewmodel.tel = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      child: Text(
                        viewmodel.userTelError,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // * ===== 인증번호 입력 필드 ===== * //
                    if (viewmodel.isCodeFieldVisible == true) ...[
                      MyTextField(
                        label: "인증번호",
                        onchange: (value) {
                          viewmodel.telCode = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                        ),
                        child: Text(
                          viewmodel.telAuthError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              if (viewmodel.isCodeFieldVisible == false) ...[
                MyButton(
                  text: "인증하기",
                  full: true,
                  type: MyButtonType.primary,
                  onpressed: (context) {
                    viewmodel.validateTel();
                  },
                ),
              ] else ...[
                MyButton(
                  text: "다음",
                  full: true,
                  type: MyButtonType.primary,
                  onpressed: (context) {
                    viewmodel.validateTelCode();
                  },
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
