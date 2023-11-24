import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/signup/add_friends.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/signup/signup.dart';
import 'package:path/path.dart';
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

  runApp(
    MultiProvider(
      // Repository Providers
      providers: getRepositories(),
      child: MultiProvider(
        // Providers
        providers: getChangeNotifiers(),
        child: MaterialApp(
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.lightBlue,
              )),
          // 라우트 정의
          routes: {
            '/app': (context) => const MyApp(),
            '/home': (context) => const MyHomePage(),
            '/landing': (context) => LandingPage(),
            '/signup': (context) => SignUpPage(),
            '/contact': (context) => AddFriendsPage(),
            '/myroom': (context) => MyRoom(),
            '/group': (context) => MyGroup(),
            '/mypage': (context) => MyPage(),
            '/friends': (context) => MyFriend(),
          },
          home: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context, listen: false);
    authService.autoLogin();
    UserInfo? user = authService.currentUser;

    if (user == null) {
      LOG.log("디바이스에 유저 정보 없음. 랜딩 페이지 이동");
    }

    return (user == null) ? LandingPage() : MyHomePage();
  }
}

// class _MyAppState extends State<MyApp> {
//   // 초기 상태 설정
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<AuthService>(
//       context,
//       listen: false,
//     ).autoLogin();
//     LOG.log("자동 로그인 시도");
//   }

  
// }
