import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:path/path.dart';

/// 서버 통신쪽 코드
class WebService {
  // 싱글톤 객체
  WebService._internal();
  static final _instance = WebService._internal();

  static const String server = Secrets.TEST_SERVER_URL;
  static WebService get instance => _instance;
  static const Map<String, String> defaultHeaders = {
    // TODO: 여기에 기본 헤더를 정의합니다.
    "Content-Type": "application/json; charset=UTF-8",
  };

  // POST
  static Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // URL 수정
    url = join(server, url);
    // 기본 헤더 추가
    if (headers != null) {
      headers.addAll(defaultHeaders);
    } else {
      headers = defaultHeaders;
    }
    // TODO: 여기서 response 형식을 수정할 수 있습니다.
    return http.post(Uri.parse(url),
        headers: headers, body: body, encoding: encoding);
  }

  // 테스트용
  Future<http.Response> test() {
    return http.get(Uri.parse(server), headers: defaultHeaders);
  }
}
