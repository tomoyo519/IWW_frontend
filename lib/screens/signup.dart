import 'package:flutter/material.dart';
import 'package:iww_frontend/screens/signup.viewmodel.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  SignUp({super.key});

  // 문자 인증 버튼 클릭
  handleContactAuth(
    BuildContext context,
  ) {
    final viewModel = context.watch<SignUpViewModel>();
    const snackBar = SnackBar(content: Text("인증번호는 0000입니다."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    viewModel.sendSms();
    viewModel.showCodeField();
  }

  // 회원가입 버튼 클릭
  handleRegister(BuildContext context) {
    final viewModel = context.read<SignUpViewModel>();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      viewModel.signIn();
    }
  }

  // 폼 유효성 검사
  bool validate() {
    return _formKey.currentState!.validate();
  }

  // 페이지 이동
  void setPage(BuildContext context, int idx) {
    final viewModel = context.read<SignUpViewModel>();

    // viewModel의 상태를 변경하고
    // 해당 상태를 참조하여 페이지를 전환
    viewModel.setPage(idx);
    _pageController.animateToPage(viewModel.pageIdx,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpViewModel>();

    return Scaffold(
        appBar: AppBar(title: const Text("회원가입")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) => viewModel.setPage(page),
            children: [
              _UserNamePage(viewModel, setPage, validate),
              _UserTelPage(viewModel, setPage, validate),
              _UserContactPage(viewModel, setPage, validate),
            ],
          ),
        ));
  }
}

/// 회원가입 단계에 따른 서브페이지들
class _UserNamePage extends StatelessWidget {
  final SignUpViewModel viewModel;
  final void Function(BuildContext, int) setPage;
  final bool Function() validate;

  const _UserNamePage(this.viewModel, this.setPage, this.validate);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            return (value != null) ? "이름을 입력해 주세요" : null;
          },
          decoration: const InputDecoration(label: Text("닉네임")),
        ),
        TextButton(
            onPressed: () {
              if (validate()) {
                setPage(context, viewModel.pageIdx + 1);
              }
            },
            child: Text("다음"))
      ],
    );
  }
}

class _UserTelPage extends StatelessWidget {
  final SignUpViewModel viewModel;
  final void Function(BuildContext, int) setPage;
  final bool Function() validate;

  const _UserTelPage(this.viewModel, this.setPage, this.validate);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            return (value != null || !value!.contains("010"))
                ? "연락처를 입력해 주세요"
                : null;
          },
          decoration: const InputDecoration(label: Text("연락처")),
        ),
        ElevatedButton(
            onPressed: () {
              if (validate()) {
                viewModel.showCodeField();
              }
            },
            child: const Text("인증번호 받기")),
        Visibility(
            visible: viewModel.isCodeFieldVisible,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    return (value != null && value != "0000")
                        ? "인증번호를 확인해 주세요"
                        : null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (validate()) {
                        setPage(context, viewModel.pageIdx + 1);
                      }
                    },
                    child: const Text("다음"))
              ],
            ))
      ],
    );
  }
}

class _UserContactPage extends StatelessWidget {
  final SignUpViewModel viewModel;
  final void Function(BuildContext, int) setPage;
  final bool Function() validate;

  const _UserContactPage(this.viewModel, this.setPage, this.validate);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
