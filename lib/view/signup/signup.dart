import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
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
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();

  // 닉네임 입력, 연락처 인증
  final _nameFormKey = GlobalKey<FormState>();
  final _telFormKey = GlobalKey<FormState>();

  SignUp({super.key});

  // 연락처 페이지로 이동
  void _nextPage(BuildContext context) {
    final viewModel = context.read<SignUpViewModel>();

    // 닉네임 입력 화면 처리
    // TODO: 중복검사 필요
    if (_nameFormKey.currentState!.validate()) {
      // ViewModel로 데이터 전송
      viewModel.name = _nameController.text;

      // UI 업데이트
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // 인증번호 받기 버튼 클릭
  void _getCode(BuildContext context) {
    if (_telFormKey.currentState!.validate()) {
      final viewModel = context.read<SignUpViewModel>();
      viewModel.sendSms();

      const snackBar = SnackBar(content: Text("인증번호는 0000입니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      viewModel.isCodeFieldVisible = true;
    }
  }

  // 인증하기 버튼 클릭
  void _doAuth(BuildContext context) {
    final viewModel = context.read<SignUpViewModel>();
    if (_telFormKey.currentState!.validate()) {
      // 데이터 전송
      viewModel.tel = _telController.text;
      // UI 업데이트
      const snackBar = SnackBar(content: Text("인증이 완료되었습니다"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      viewModel.isRegisterBtnEnabled = true;
    }
  }

  // 회원가입 버튼 클릭
  void _signup(BuildContext context) async {
    final viewModel = context.read<SignUpViewModel>();
    if (_telFormKey.currentState!.validate()) {
      // 회원가입 요청
      await viewModel.signUp().then((userInfo) {
        if (userInfo != null) {
          _pageController.dispose(); // 해제
          LOG.log("Succeeded in signing up");
          Navigator.pushNamedAndRemoveUntil(
              context, "/contact", ((route) => false));
          return;
        }
        viewModel.disconnect();
        LOG.log("Faild to signup");
        GlobalNavigator.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("/landing", (route) => false);
      });
    } else {
      viewModel.disconnect();
      LOG.log("Exception while signing up");
      GlobalNavigator.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil("/landing", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpViewModel>();

    return Scaffold(
        appBar: MyAppBar(title: const Text("회원가입")),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Form(
                    key: _nameFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            return (value == null || value.isEmpty)
                                ? "이름을 입력해 주세요"
                                : null;
                          },
                          decoration: const InputDecoration(label: Text("닉네임")),
                        ),
                        ElevatedButton(
                            onPressed: () => _nextPage(context),
                            child: Text("다음"))
                      ],
                    )),
                Form(
                    key: _telFormKey,
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _telController,
                              validator: (value) {
                                return (value == null ||
                                        value.isEmpty ||
                                        // TODO regex
                                        !value.contains("010"))
                                    ? "연락처를 입력해 주세요"
                                    : null;
                              },
                              decoration:
                                  const InputDecoration(label: Text("연락처")),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () => _getCode(context),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(100, 45)),
                              child: const Text("인증번호 받기")),
                        ],
                      ),
                      Visibility(
                        visible: viewModel.isCodeFieldVisible,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      return (value == null ||
                                              value.isEmpty ||
                                              value != "0000")
                                          ? "인증번호를 확인해 주세요"
                                          : null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () => _doAuth(context),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 45)),
                                    child: const Text("인증하기")),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: viewModel.isRegisterBtnEnabled
                                    ? () => _signup(context)
                                    : null,
                                child: const Text("회원가입")),
                          ],
                        ),
                      )
                    ])),
              ],
            ),
          ),
        ));
  }
}
