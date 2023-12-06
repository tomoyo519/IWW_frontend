// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/providers.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/loading.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

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

  // 3. 테스트유저 접속
  // await authService.testLogin();

  // authService.status = AuthStatus.initialized;
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
          theme: getapptheme(),
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

    UserInfo? userInfo;
    if (authService.status == AuthStatus.initialized) {
      LOG.log(emoji: 2, "${authService.user!.user_id}");

      UserModel user = authService.user!;
      Item mainPet = authService.mainPet!;
      UserRepository repository =
          Provider.of<UserRepository>(context, listen: false);
      userInfo = UserInfo(user, mainPet, repository);
    }

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
                  ChangeNotifierProvider.value(
                    value: userInfo!,
                  ),
                  // ChangeNotifierProvider(
                  //   create: (context) => UserInfo(
                  //     authService.user!,
                  //     authService.mainPet!,
                  //     Provider.of<UserRepository>(context, listen: false),
                  //   ),
                  // ),
                ],
                child: MainPage(), // lib/view/main_page.dart
              );
  }
}
