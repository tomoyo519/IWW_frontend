import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';
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
import 'package:iww_frontend/view/inventory/inventory.dart';

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

  // 앱 진입 시 로그인
  // authService.localLogin();

  // 만약 테스트유저 접속시
  authService.user = UserInfo(
    user_id: 1,
    user_name: "sojeong",
    user_tel: "010-0000-0000",
    user_kakao_id: "user_kakao_id",
    user_hp: 0,
  );
  authService.waiting = false;

  runApp(
    MultiProvider(
      providers: getRepositories(),
      child: MultiProvider(
        providers: [
          Provider<UserRepository>(
            create: (context) => userRepository,
          ),
          ChangeNotifierProvider<AuthService>(
            create: (context) => authService,
          ),
        ],
        child: MaterialApp(
          navigatorKey: GlobalNavigator.navigatorKey,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.lightBlue,
              )),
          home: LoginWrapper(child: MyHomePage()),
          routes: {
            // 회원가입 또는 랜딩 페이지
            '/signup': (context) => SignUpPage(),
            '/landing': (context) => LandingPage(),

            // 유저만 접근 가능한 페이지
            '/home': (context) => LoginWrapper(child: MyHomePage()),
            '/contact': (context) => LoginWrapper(child: AddFriendsPage()),
            '/myroom': (context) => LoginWrapper(child: MyRoom()),
            '/group': (context) => LoginWrapper(child: MyGroup()),
            '/mypage': (context) => LoginWrapper(child: MyPage()),
            '/friends': (context) => LoginWrapper(child: MyFriend()),
            '/shop': (context) => LoginWrapper(child: ShopPage())
          },
        ),
      ),
    ),
  );
}

class LoginWrapper extends StatelessWidget {
  final Widget child;
  LoginWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool waiting = context.watch<AuthService>().waiting;
    final UserInfo? user = context.watch<AuthService>().user;

    return waiting
        ? Placeholder()
        : (user == null)
            ? LandingPage()
            : Provider<UserInfo>.value(value: user, child: child);
  }
}
