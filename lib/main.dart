// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() async {
  // * ======================= * //
  // *                         * //
  // *     Initialize App      * //
  // *                         * //
  // * ======================= * //

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Secrets.KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: Secrets.KAKAO_JS_APP_KEY,
  );

  // navigation status 초기화
  AppNavigator navigator = AppNavigator();

  // Date formatter 초기화
  await initializeDateFormatting('ko_KO', null);

  // 인증에 필요한 리포지토리 및 서비스 초기화
  UserRepository userRepository = UserRepository();
  AuthService authService = AuthService(userRepository);

  // * ======================= * //
  // *                         * //
  // *     Initialize User     * //
  // *                         * //
  // * ======================= * //

  // 1. 로컬 로그인
  await authService.localLogin();

  // 2. 카카오로 로그인 시도
  // authService.oauthLogin(signup: false);

  // authService.status = AuthStatus.initialized;
  // authService.waiting = false;

  // exception error 가 발생하는 경우, 앱이 꺼지지않고 아래 화면 보이도록 설정
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Expanded(
            child: Column(
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/wrong.json',
                repeat: true,
                animate: true,
              ),
            ),
            Text(
              '문제가 발생했어요! 뒤로 가볼까요?',
            )
          ],
        )),
      ),
    );
  };

  runApp(
    MultiProvider(
      providers: getRepositories(),
      child: MultiProvider(
        providers: [
          // Signup
          Provider<UserRepository>.value(
            value: userRepository,
          ),
          ChangeNotifierProvider<AuthService>.value(
            value: authService,
          ),
          ChangeNotifierProvider<AppNavigator>.value(
            value: navigator,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getapptheme(),
          home: RenderPage(),
        ),
      ),
    ),
  );
}

//** 로그인 여부에 따라 화면을 이동합니다.
// 미인증 사용자인 경우 → Landing
// 인증된 사용자인 경우 → MainPage
// */
class RenderPage extends StatelessWidget {
  const RenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppNavigator nav = context.read<AppNavigator>();
    AuthService authService = context.watch<AuthService>();
    UserInfo? userInfo;

    if (authService.status == AuthStatus.initialized) {
      // 사용자 전역 상태관리 객체 초기화
      UserModel user = authService.user!;
      UserRepository repo = Provider.of<UserRepository>(context, listen: false);
      userInfo = UserInfo(repo, authService);

      // 이벤트 서비스 초기화
      EventService.setUserId(user.user_id);
      EventService.initialize(userInfo);
    }

    nav.setToDefault();

    return authService.status != AuthStatus.initialized
        ? LandingPage()
        : MultiProvider(
            providers: [
              // 인증된 사용자의 경우 아래와 같은 정보 주입
              ChangeNotifierProvider.value(
                value: context.read<AppNavigator>(),
              ),
              ChangeNotifierProvider.value(
                value: userInfo!,
              ),
            ],
            child: MainPage(), // lib/view/main_page.dart
          );
  }
}
