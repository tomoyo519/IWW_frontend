import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/loading.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/signup/add_friends.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/signup/signup.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:iww_frontend/model/routine/routine.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

// >>> generate todo test
// var routines = [
//   Routine.fromJson({
//     "rout_id": 1,
//     "rout_name": "routin1",
//     "rout_desc": "test",
//     "rout_repeat": "1111100",
//     "grp_id": 1
//   }),
//   Routine.fromJson({
//     "rout_id": 2,
//     "rout_name": "routin2",
//     "rout_desc": "test",
//     "rout_repeat": "0001000",
//     "grp_id": 1
//   }),
//   Routine.fromJson({
//     "rout_id": 3,
//     "rout_name": "routin3",
//     "rout_desc": "test",
//     "rout_repeat": "1111111",
//     "grp_id": 1
//   }),
// ];
// const int userId = 1;

// for (var element in routines) {
//   Todo todo = element.generateTodo(userId);
//   Todo.requestCreate(todo.toJson());
//   print(todo..toJson());
// }
// <<< generate todo test

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
              '/shop':(context) => ShopPage()
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
    AuthService authService = context.watch<AuthService>();
    AuthStatus status = authService.status;

    switch (status) {
      case AuthStatus.success:
        return MyHomePage();
      case AuthStatus.waiting:
        return LoadingPage();
      case AuthStatus.failed:
        return LandingPage();
      case AuthStatus.permission:
        return LandingPage();
    }
  }
}
