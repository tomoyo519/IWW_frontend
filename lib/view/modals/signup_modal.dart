import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpModal extends StatefulWidget {
  SignUpModal({
    super.key,
  });

  @override
  State<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _passwordCheckController = TextEditingController();

  final _petnameController = TextEditingController();

  String errorMsg = '';

  bool isSignup = true;

  void _signIn() async {
    if (_passwordCheckController.text != _passwordController.text) {
      errorMsg = "비밀번호가 같지 않습니다.";
      return;
    }

    // if (res.statusCode == 201) {}
    // 실제 앱에서는 여기에 사용자 인증 로직을 추가해야 합니다.
  }

  @override
  Widget build(BuildContext context) {
    final AuthService service = context.watch<AuthService>();
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Container(
        height: isKeyboardOpen ? 760 : 560,
        child: FractionallySizedBox(
          heightFactor: isKeyboardOpen ? 1 : 0.8,
          child: Column(
            children: [
              isSignup
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("회원가입을 해봐요!"),
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: '아이디',
                              ),
                            ),
                            TextField(
                              controller: _petnameController,
                              decoration: InputDecoration(
                                labelText: '펫이름',
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                              ),
                              obscureText: true,
                            ),
                            TextField(
                              controller: _passwordCheckController,
                              decoration: InputDecoration(
                                labelText: '비밀번호 확인',
                              ),
                              obscureText: true,
                            ),
                            Text(errorMsg),
                            SizedBox(height: 20),
                            ElevatedButton(
                              child: Text('회원가입'),
                              onPressed: () async {
                                final res = await RemoteDataSource.post(
                                    "/auth/signup",
                                    body: {
                                      "user_name": _usernameController.text,
                                      "user_pet_name": _petnameController.text,
                                      "user_pwd": _passwordController.text,
                                    }).then((res) {
                                  LOG.log("${res.statusCode}");
                                  _usernameController.clear();
                                  _passwordController.clear();
                                  service.signup(_usernameController.text, "0",
                                      _petnameController.text);

                                  // authService.waiting = false
                                  setState(() {
                                    isSignup = false;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("로그인을 해봐요!"),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: '아이디',
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: '비밀번호',
                            ),
                            obscureText: true,
                          ),
                          ElevatedButton(
                            child: Text('로그인'),
                            onPressed: () async {
                              final res = await RemoteDataSource.post(
                                  "/auth/login",
                                  body: {
                                    "user_name": _usernameController.text,
                                    "user_pwd": _passwordController.text,
                                  }).then((res) {
                                print('ehello');
                                LOG.log("${res.body}");
                                LOG.log("${res.statusCode}");
                                service.localLogin();
                              });
                            },
                          ),
                        ],
                      ))
              // Lottie.asset(
              //   "assets/star.json",
              //   animate: true,
              //   width: screen.width * 0.5,
              // ),
              // Text(
              //   "👀 두윗이 처음이시네요!",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 25,
              //   ),
              // ),
              // Text(
              //   "펫과 함께하는 투두 여정을 시작할 준비가 되셨나요?",
              //   style: TextStyle(
              //     fontSize: 13,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: MyButton(
              //     text: "회원가입",
              //     full: true,
              //     type: MyButtonType.primary,
              //     onpressed: (context) {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: MyButton(
              //     text: "취소하기",
              //     full: true,
              //     type: MyButtonType.shaded,
              //     onpressed: (context) {
              //       context.read<AuthService>().status = AuthStatus.failed;
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
