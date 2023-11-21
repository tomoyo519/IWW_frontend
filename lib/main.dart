// msg: 가능하면 건드리지 말자 by 다희 소정
import 'package:flutter/material.dart';
import 'package:iww_frontend/add_todo.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home.dart';
import 'package:iww_frontend/utils/loginPreview.dart';
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
    ],
    child: MaterialApp(
      home: const MyApp(),
      // key: TwService.appKey,
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
        child: LoginPreview(),
      ),
    );
  }
}
