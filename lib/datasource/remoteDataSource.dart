import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/utils/logger.dart';

/// 서버 통신쪽 코드
class RemoteDataSource {
  // 싱글톤 객체
  RemoteDataSource._internal();
  static final _instance = RemoteDataSource._internal();

  static const String server = Secrets.REMOTE_SERVER_URL;
  static RemoteDataSource get instance => _instance;
  static Map<String, String> baseHeaders = {
    // TODO: 여기에 기본 헤더를 정의합니다.
    "Content-Type": "application/json; charset=UTF-8",
  };

  // 인증 완료 시 Authorization 헤더 추가
  static void setAuthHeader(String token) {
    baseHeaders['Authorization'] = token;
  }

  // POST form data
  static Future<http.StreamedResponse> postFormData(String url, String field,
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
        field,
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
      ));
    }
    return await request.send();
  }

//PATCH form data
  static Future<http.StreamedResponse> patchFormData(String url, String field,
      {Map<String, dynamic>? body, File? file, String? filename}) async {
    var request = http.MultipartRequest('PATCH', Uri.parse(server + url));

    if (body != null) {
      // 요청 본문
      for (String key in body.keys) {
        request.fields[key] = body[key];
      }
    }
    if (file != null) {
      LOG.log("[PATCH FORMDATA] ${server + url} $filename");
      request.files.add(await http.MultipartFile.fromPath('file', filename!));
      var res = await request.send();
      LOG.log("[PATCH FORMDATA] Responsed: ${res.statusCode}");
      return res;
    } else {
      throw Exception('file must not be null');
    }
  }

  // POST json
  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;

    // Json string으로 변환하여 요청
    String? bodyString = body == null
        ? null
        : body is Map
            ? json.encode(body)
            : body.toString();
    LOG.log("[POST] ${server + url} $bodyString");
    return await http.post(
      Uri.parse(server + url),
      headers: headers,
      body: bodyString,
      encoding: encoding,
    );
  }

  // GET json
  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;
    LOG.log("[GET] ${server + url}");
    return await http.get(Uri.parse(server + url), headers: headers);
  }

  // PUT json
  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;
    // Json string으로 변환하여 요청
    String? bodyString = body == null
        ? null
        : body is Map
            ? json.encode(body)
            : body.toString();

    LOG.log("[PUT] ${server + url} $bodyString");
    return await http.put(
      Uri.parse(server + url),
      headers: headers,
      body: bodyString,
      encoding: encoding,
    );
  }

  // PATCH
  static Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;
    // Json string으로 변환하여 요청
    String? bodyString = body == null
        ? null
        : body is Map
            ? json.encode(body)
            : body.toString();

    LOG.log("[PATCH] ${server + url} $bodyString");
    return await http.patch(
      Uri.parse(server + url),
      headers: headers,
      body: bodyString,
      encoding: encoding,
    );
  }

  // DELETE json
  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    // 기본 헤더 추가
    headers = (headers != null) ? {...headers, ...baseHeaders} : baseHeaders;
    // Json string으로 변환하여 요청
    String? bodyString = body == null
        ? null
        : body is Map
            ? json.encode(body)
            : body.toString();

    LOG.log("[DELETE] ${server + url} $bodyString");
    return await http.delete(Uri.parse(server + url),
        headers: headers, body: body, encoding: encoding);
  }

  // 테스트용
  static Future<http.Response> test() {
    return http.get(
      Uri.parse(server),
      headers: baseHeaders,
    );
  }
}
