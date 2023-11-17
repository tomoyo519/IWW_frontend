import 'package:flutter/material.dart';
import 'package:iww_frontend/screens/signup.viewmodel.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final SignUpViewModel viewModel = SignUpViewModel();
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  SignUp({super.key});

  // 문자 인증 버튼 클릭
  handleContactAuth(context) {
    const snackBar = SnackBar(content: Text("인증번호는 0000입니다."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    viewModel.sendSms();
    viewModel.showCodeField();
  }

  // 회원가입 버튼 클릭
  handleRegister() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      viewModel.signIn();
    }
  }

  // 페이지 이동
  void setPage() {
    _pageController.animateToPage(viewModel.pageIdx,
        duration: const Duration(microseconds: 400), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignUpViewModel(),
        child: Scaffold(
            appBar: AppBar(title: const Text("회원가입")),
            body: ChangeNotifierProvider<SignUpViewModel>(
                create: (_) => viewModel,
                child: Consumer<SignUpViewModel>(
                  builder: (context, model, child) {
                    return PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) => model.setPage(page),
                      children: <Widget>[
                        _UserNamePage(model),
                        _UserTelPage(model),
                        _UserContactPage(model),
                      ],
                    );
                  },
                ))));
  }
}

/// private page classes
class _UserNamePage extends StatelessWidget {
  final SignUpViewModel viewModel;
  const _UserNamePage(this.viewModel);

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
        TextButton(onPressed: () => viewModel.setPage(1), child: Text("다음"))
      ],
    );
  }
}

class _UserTelPage extends StatelessWidget {
  final SignUpViewModel viewModel;
  const _UserTelPage(this.viewModel);

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
            onPressed: () => viewModel.showCodeField(),
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
                    onPressed: () => viewModel.setPage(2),
                    child: const Text("다음"))
              ],
            ))
      ],
    );
  }
}

class _UserContactPage extends StatelessWidget {
  final SignUpViewModel viewModel;
  const _UserContactPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
