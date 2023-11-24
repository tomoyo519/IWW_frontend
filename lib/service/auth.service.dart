import 'dart:convert';
import 'dart:developer';

import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final KaKaoLogin kakaoLogin;
  final UserRepository userRepository;

  // 의존성 주입
  AuthService(this.kakaoLogin, this.userRepository);

  // 현재 로그인된 유저 상태
  UserInfo? _currentUser;

  set currentUser(UserInfo? user) {
    _currentUser = user;
    log("Current user: ${_currentUser?.user_id ?? "none"}");
  }

  // 로그인된 유저 정보를 가져옴
  Future<UserInfo?> getCurrentUser() async {
    UserInfo? localUserInfo = await userRepository.getUserFromLocal();
    currentUser = localUserInfo;
    return localUserInfo;
  }

  // 네트워크 연결된 경우 로그인 로직
  // 로컬 로그인이 가능하거나 DB에 유저 정보가 있으면 true
  // 그렇지 않은 경우 false 반환
  Future<LoginResult> login() async {
    // 로컬 로그인이 가능한 경우
    UserInfo? userInfo = await userRepository.getUserFromLocal();
    if (await _localLogin()) {
      return LoginResult(
        status: LoginStatus.success,
        user: userInfo,
      );
    }

    // 카카오 인증 후 유저 정보에서 카카오 아이디 확인
    LoginStatus status = await kakaoLogin.login();
    log("Login status: $status");
    if (status == LoginStatus.success) {
      // DB에서 유저 정보를 확인하고
      // 가입된 사용자일 경우 로컬 저장소에 캐시
      User? user = await kakaoLogin.getUserInfo();
      if (user == null) {
        return LoginResult(
          status: status,
          user: null,
        );
      }

      String kakaoId = user.id.toString();
      UserInfo? userInfo = await userRepository.getUserByKakaoId(kakaoId);
      if (userInfo != null && await userRepository.saveUserInLocal(userInfo)) {
        return LoginResult(
          status: LoginStatus.success,
          user: userInfo,
        );
      }
    }

    return LoginResult(
      status: status,
      user: null,
    );
  }

  // 회원가입 로직
  Future<UserInfo?> signup(String userName, String userTel) async {
    // 카카오 인증 후 유저 정보에서 카카오 아이디 확인
    LoginStatus? status = await kakaoLogin.login();
    if (status == LoginStatus.permission) {
      return null;
    }

    // 카카오에서 유저 정보 가져오기
    User? user = await kakaoLogin.getUserInfo();
    if (user == null) {
      return null;
    }

    // 로컬, 원격 모두에서 유저 생성
    var userKakaoId = user.id.toString();
    UserInfo? userInfo =
        await userRepository.createUser(userName, userTel, userKakaoId);

    if (userInfo == null) {
      log("Failed to create user");
      return null;
    }

    // 유저 생성 완료된 경우 프로필 사진 저장
    // TODO: UserRepository쪽으로 빼기
    String? profileUrl = user.kakaoAccount?.profile?.profileImageUrl;
    if (profileUrl != null) {
      // 프로필 사진이 있는 경우 로컬스토리지에 저장
      var title = userInfo.user_id;
      var filepath = await LocalStorage.save(profileUrl, '$title.jpg');
      if (filepath != null) {
        // 서버로 올리기
        var isCreated = await userRepository.createUserProfile(title);
        if (!isCreated) {
          // 서버로 안올라갔으면 로컬에서도 삭제
          await LocalStorage.delete(filepath);
        }
      }
    }

    // 상태 변경
    currentUser = userInfo;
    return userInfo;
  }

  // 로그아웃
  Future<bool> logout() async {
    // 디바이스 SharedPreference에 저장된 모든 관련 정보 삭제하고
    bool isLocalLoggedOut = await userRepository.deleteUserInLocal();
    // 카카오 SDK에 저장된 정보도 삭제
    bool isKakaoLoggedOut = await kakaoLogin.logout();

    log("${isLocalLoggedOut ? "Succeed" : "Failed"} to delete local user info");
    log("${isKakaoLoggedOut ? "Succeed" : "Failed"} to logout from kakao");

    // 상태 변경
    currentUser = null;
    return isLocalLoggedOut && isKakaoLoggedOut;
  }

  // 회원 탈퇴
  Future<bool> disconnect() async {
    // 저장된 유저 정보
    UserInfo? localUserInfo = await userRepository.getUserFromLocal();
    User? kakaoUserInfo = await kakaoLogin.getUserInfo();

    // 디바이스 SharedPreference에 저장된 모든 관련 정보 삭제하고
    bool isLocalDisconnect = await userRepository.deleteUserInLocal();

    // 카카오 OAuth와도 연결 끊기
    bool isKakaoDisconnect = await kakaoLogin.disconnect();

    log("${isLocalDisconnect ? "Succeed" : "Failed"} to delete local user info");
    log("${isKakaoDisconnect ? "Succeed" : "Failed"} to disconnect from kakao");

    // 서버에 삭제 요청
    bool isDisconnect;
    if (localUserInfo != null) {
      isDisconnect = await userRepository.deleteUserById(localUserInfo.user_id);
      log("${isDisconnect ? "Succeed" : "Failed"} to delete remote user info");

      // 상태 변경
      currentUser = null;
      return true;
    }

    if (kakaoUserInfo != null) {
      isDisconnect =
          await userRepository.deleteUserByKakaoId(kakaoUserInfo.id.toString());
      log("${isDisconnect ? "Succeed" : "Failed"} to delete remote user info");

      // 상태 변경
      currentUser = null;
      return true;
    }

    // TODO: 유저가 정상적으로 탈퇴되지 않음
    log("! 유저가 정상적으로 탈퇴되지 않음");
    return false;
  }

  /// ==== helpers ==== ///
  // 로컬 로그인
  Future<bool> _localLogin() async {
    // 디바이스에 캐시된 유저 정보가 있고
    // 토큰 만료 이전이면 네트워크 없이도 로그인 처리
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int? expireAt = pref.getInt("token_expire");
    if (expireAt == null) {
      return false;
    }

    DateTime expire = DateTime.fromMillisecondsSinceEpoch(expireAt);
    if (expire.isBefore(DateTime.now())) {
      return false;
    }

    // 유저 정보 확인
    UserInfo? user = await userRepository.getUserFromLocal();
    if (user == null) {
      return false;
    }

    // 상태 변경
    currentUser = user;
    return true;
  }
}
