import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/view/_navigation/routes.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/loading.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/_navigation/transition.dart';
import 'package:iww_frontend/view/notification/notification.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/viewmodel/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

class GlobalNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigate(String path) async {
    GlobalNavigator.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(path, (route) => false);
  }
}

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Secrets.KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: Secrets.KAKAO_JS_APP_KEY,
  );

  // 인증에 필요한 리포지토리 및 서비스 초기화
  UserRepository userRepository = UserRepository();
  AuthService authService = AuthService(userRepository);

  // 앱 진입 시 로컬 로그인 시도
  // await authService.localLogin();

  // 만약 테스트유저 접속시
  authService.user = UserModel(
    user_id: 1,
    user_name: "sojeong",
    user_tel: "010-0000-0000",
    user_kakao_id: "user_kakao_id",
    user_hp: 0,
    user_cash: 0,
    last_login: "",
    login_cnt: 0,
    login_seq: 0,
  );
  authService.waiting = false;

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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: GlobalNavigator.navigatorKey,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Pretendard',
          ),

          //** 로그인 여부에 따라 화면을 이동합니다.
          // 미인증 사용자인 경우 → Landing
          // 인증된 사용자인 경우 → MainPage
          // */
          home: authService.waiting
              ? LoadingPage()
              : authService.user == null
                  ? LandingPage()
                  : MultiProvider(
                      // 인증된 사용자의 경우 아래와 같은 정보 주입
                      providers: [
                        // Provider<UserInfo>.value(
                        //   value: authService.user!,
                        // ),
                        ChangeNotifierProvider(
                          create: (context) => UserInfo(
                            Provider.of<UserRepository>(context, listen: false),
                            authService.user!,
                          ),
                        ),
                      ],
                      child: MainPage(),
                    ), // lib/view/main_page.dart

          routes: ROUTE_TABLE, // lib/route.dart

          //** Navigator에 푸시될 때 트랜지션
          // /notification:  Right Popup
          // */
          onGenerateRoute: (settings) {
            if (settings.name == '/notification') {
              return RightPopupTransition.builder(child: MyNotification());
            }
            return null;
          },
        ),
      ),
    ),
  );
}
