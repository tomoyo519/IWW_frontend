import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iww_frontend/secrets/secrets.dart';

// 콘텐트 타입
enum ContentType {
  json,
  formdata;

  String get type {
    switch (this) {
      case ContentType.json:
        return "application/json; charset=UTF-8";
      case ContentType.formdata:
        return "multipart/form-data";
    }
  }
}

/// 서버 통신쪽 코드
class RemoteDataSource {
  // 싱글톤 객체
  RemoteDataSource._internal();
  static final _instance = RemoteDataSource._internal();

  static const String server = Secrets.TEST_SERVER_URL;
  static RemoteDataSource get instance => _instance;
  static const Map<String, String> baseHeaders = {
    // TODO: 여기에 기본 헤더를 정의합니다.
    "Content-Type": "application/json; charset=UTF-8",
  };

  // POST form data
  static Future<http.StreamedResponse> postFormData(String url,
      {Map<String, dynamic>? body, File? file, String? filename}) async {
    var request = http.MultipartRequest('POST', Uri.parse(server + url));
    if (body != null) {
      // 요청 본문
      for (String key in body.keys) {
        request.fields[key] = body[key];
      }
    }
    if (file != null) {
      // 파일
      request.files.add(http.MultipartFile(
          'file', file.readAsBytes().asStream(), file.lengthSync(),
          filename: filename));
    }
    return await request.send();
  }

  // POST json
  static Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;

    // Json string으로 변환하여 요청
    String bodyString = body is Map ? json.encode(body) : body.toString();

    return await http.post(Uri.parse(server + url),
        headers: headers, body: bodyString, encoding: encoding);
  }

  // GET json
  static Future<http.Response> get(String url,
      {Map<String, String>? headers}) async {
    if (headers != null) {
      // 기본 헤더 추가
      headers.addAll(baseHeaders);
    } else {
      headers = baseHeaders;
    }
    return await http.get(Uri.parse(server + url), headers: headers);
  }

  // 테스트용
  Future<http.Response> test() {
    return http.get(Uri.parse(server), headers: baseHeaders);
  }
}
