import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:iww_frontend/screens/signup.viewmodel.dart';
import 'package:provider/provider.dart';

/// 회원가입
class SignUp extends StatelessWidget {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();

  // 닉네임 입력, 연락처 인증
  final _nameFormKey = GlobalKey<FormState>();
  final _telFormKey = GlobalKey<FormState>();
  SignUp({super.key});

  // 문자 인증 버튼 클릭
  void _getSms(
    BuildContext context,
  ) {
    final viewModel = context.read<SignUpViewModel>();
    viewModel.sendSms();

    const snackBar = SnackBar(content: Text("인증번호는 0000입니다."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 페이지 이동
  void _nextPage(BuildContext context) {
    final viewModel = context.read<SignUpViewModel>();
    final currPage = _pageController.page;

    if (_pageController.page == 0) {
      // 닉네임 입력 화면 처리
      // TODO 중복검사 필요
      if (_nameFormKey.currentState!.validate()) {
        // ViewModel로 데이터 전송
        viewModel.name = _nameController.text;
        log("currpage: ${_pageController.page}, data: ${viewModel.name}");

        // UI 업데이트
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        log("currpage: ${_pageController.page}, data: ${viewModel.name}");

        // viewModel.pageIdx++;
      }
    } else if (currPage == 1) {
      // 연락처 인증 완료 후 화면 처리
      if (_telFormKey.currentState!.validate()) {
        viewModel.tel = _telController.text;

        // 회원가입 완료
        viewModel.signUp();

        // UI 업데이트
        _pageController.dispose();
        // viewModel.pageIdx++;
      }
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
                              onPressed: () {
                                _getSms(context);
                                viewModel.isCodeFieldVisible = true;
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(100, 45)),
                              child: const Text("인증번호 받기")),
                        ],
                      )
                    ])),
                Text("hehe"),

                // Form(
                //     key: _telFormKey,
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             TextFormField(
                //               controller: _telController,
                //               validator: (value) {
                //                 return (value == null ||
                //                         value.isEmpty ||
                //                         !value.contains("010"))
                //                     ? "연락처를 입력해 주세요"
                //                     : null;
                //               },
                //               decoration:
                //                   const InputDecoration(label: Text("연락처")),
                //             ),
                //             ElevatedButton(
                //                 onPressed: () {
                //                   _getSms(context);
                //                   viewModel.isCodeFieldVisible = true;
                //                 },
                //                 child: const Text("인증번호 받기")),
                //           ],
                //         ),
                // Visibility(
                //     visible: viewModel.isCodeFieldVisible,
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             TextFormField(
                //               validator: (value) {
                //                 return (value == null ||
                //                         value.isEmpty ||
                //                         value != "0000")
                //                     ? "인증번호를 확인해 주세요"
                //                     : null;
                //               },
                //             ),
                //             ElevatedButton(
                //                 onPressed: () => _nextPage(context),
                //                 child: const Text("인증하기"))
                //           ],
                //         ),
                //         ElevatedButton(
                //             onPressed: viewModel.isRegisterBtnEnabled
                //                 ? () => _nextPage(context)
                //                 : null,
                //             child: const Text("회원가입")),
                //       ],
                //     ))
                //       ],
                //     )),
              ],
            ),
          ),
        ));
  }
}
