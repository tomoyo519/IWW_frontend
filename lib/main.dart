// msg: 가능하면 건드리지 말자 by 다희 소정
import 'package:flutter/material.dart';
import 'package:iww_frontend/add_todo.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/myroom.dart';
import 'package:iww_frontend/screens/findContact.dart';
import 'package:iww_frontend/screens/findContact.viewmodel.dart';
import 'package:iww_frontend/screens/landing.dart';
import 'package:iww_frontend/screens/signup.dart';
import 'package:iww_frontend/screens/signup.viewmodel.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home.dart';
import 'package:iww_frontend/utils/appEntries.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
// import 'package:tailwind/tailwind.dart';

void main() async {
  // await TwService.init();

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Secrets.KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: Secrets.KAKAO_JS_APP_KEY,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SelectedDate>(
        create: (context) => SelectedDate(),
      ),
      ChangeNotifierProvider<NewTodo>(create: (context) => NewTodo())
      Provider<UserRepository>(create: (_) => UserRepository()),
      Provider<FriendRepository>(create: (_) => FriendRepository()),
    ],
    child: MaterialApp(
        // 라우트 정의
        routes: {
          '/landing': (context) => const Landing(),
          '/home': (context) => const MyHome(),
          '/signup': (context) => ChangeNotifierProvider<SignUpViewModel>(
                create: (_) => SignUpViewModel(
                    Provider.of<UserRepository>(_, listen: false)),
                child: SignUp(),
              ),
          '/contact': (context) => ChangeNotifierProvider<FindContactViewModel>(
                create: (_) => FindContactViewModel(
                    Provider.of<UserRepository>(_, listen: false),
                    Provider.of<FriendRepository>(_, listen: false)),
                child: AddFriends(),
              ),
          '/myroom': (context) => MyRoom(),
        },
        home: MyApp()),
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
