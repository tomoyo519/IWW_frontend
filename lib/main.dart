import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
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
import 'package:path/path.dart';
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

          home: RenderPage(auth: authService),
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

//** 로그인 여부에 따라 화면을 이동합니다.
// 미인증 사용자인 경우 → Landing
// 인증된 사용자인 경우 → MainPage
// */
class RenderPage extends StatefulWidget {
  final AuthService auth;
  const RenderPage({super.key, required this.auth});

  @override
  State<RenderPage> createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    // 1. 카카오 로그인 로직
    _sub = widget.auth.listenRedirect();
    widget.auth.login();

    // 2. 로컬 로그인 로직
    // 카카오 로그인으로 연결하기 위해 스토리지에 저장된 정보 삭제
    // LocalStorage.clearKey().then((value) {
    //   widget.auth.localLogin();
    // });

    // 3. 테스트유저 접속
    // widget.auth.user = UserModel(
    //   user_id: 1,
    //   user_name: "sojeong",
    //   user_tel: "010-0000-0000",
    //   user_kakao_id: "user_kakao_id",
    //   user_hp: 0,
    //   user_cash: 0,
    //   last_login: "",
    //   login_cnt: 0,
    //   login_seq: 0,
    // );

    widget.auth.waiting = false;
  }

  @override
  void dispose() {
    super.dispose();
    // 스트림 해제
    if (_sub != null) {
      _sub!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = context.watch<AuthService>();
    return auth.waiting
        ? LoadingPage()
        : auth.user == null
            ? LandingPage()
            : MultiProvider(
                // 인증된 사용자의 경우 아래와 같은 정보 주입
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => UserInfo(
                      auth,
                      Provider.of<UserRepository>(context, listen: false),
                      auth.user!,
                    ),
                  ),
                ],
                child: MainPage(), // lib/view/main_page.dart
              );
  }
}
