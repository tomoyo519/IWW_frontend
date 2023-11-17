import 'package:http/http.dart' as http;
import 'package:iww_frontend/screens/landing.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';

/// 서버 통신쪽 코드
class WebService {
  // 싱글톤 객체
  WebService._internal();
  static final _instance = WebService._internal();
  static WebService get instance => _instance;

  static String server = Secrets.LOCAL_SERVER_URL;
  static final Map<String, String> defaultHeaders = {
    "Content-Type": "application/json; charset=UTF-8",
  };

  Future<http.Response> hello() {
    return http.get(Uri.parse(server), headers: defaultHeaders);
  }

  Future<http.Response> createUser(UserLoginModel userLoginModel) {
    return http.post(Uri.parse("$server/auth"),
        headers: defaultHeaders, body: userLoginModel);
  }
}
