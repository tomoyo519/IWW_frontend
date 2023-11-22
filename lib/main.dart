// msg: 가능하면 건드리지 말자 by 다희 소정
import 'package:flutter/material.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/view/screens/myroom.dart';
import 'package:iww_frontend/view/screens/addFriends.dart';
import 'package:iww_frontend/view/screens/landing.dart';
import 'package:iww_frontend/view/screens/signup.dart';
import 'package:iww_frontend/view/screens/myPage.dart';
import 'package:iww_frontend/view/widget/groupMain.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/view/widget/home.dart';
import 'package:iww_frontend/utils/appEntries.dart';
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

  runApp(MultiProvider(
    // Repository Providers
    providers: getRepositories(),
    child: MultiProvider(
      // Service Providers
      providers: getServices(),
      child: MultiProvider(
        // ViewModel Providers
        providers: getChangeNotifiers(),
        child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            // 라우트 정의
            routes: {
              '/home': (context) => const MyHome(),
              '/landing': (context) => LandingPage(),
              '/signup': (context) => SignUpPage(),
              '/contact': (context) => AddFriendsPage(),
              '/myroom': (context) => MyRoom(),
              '/group': (context) => MyGroup(),
              '/mypage': (context) => MyPage(),
            },
            home: MyApp()),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        // 유저 로그인 여부에 따른 앱 진입 시나리오
        child: AppEntries(),
      ),
    );
  }
}
