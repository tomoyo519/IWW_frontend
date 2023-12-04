import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/loading.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Secrets.KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: Secrets.KAKAO_JS_APP_KEY,
  );

  // navigation status 초기화
  AppNavigator navigator = AppNavigator();

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

  // 3. 테스트유저 접속
  // authService.testLogin();

  // authService.status = AuthStatus.permission;
  // authService.waiting = false;

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
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Pretendard',
          ),
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
    AuthService authService = context.watch<AuthService>();
    return authService.waiting
        ? LoadingPage()
        : authService.status != AuthStatus.initialized
            ? LandingPage()
            : MultiProvider(
                providers: [
                  // 인증된 사용자의 경우 아래와 같은 정보 주입
                  ChangeNotifierProvider.value(
                    value: context.read<AppNavigator>(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => UserInfo(
                      authService.user!,
                      authService.mainPet!,
                      Provider.of<UserRepository>(context, listen: false),
                    ),
                  ),
                ],
                child: MainPage(), // lib/view/main_page.dart
              );
  }
}
