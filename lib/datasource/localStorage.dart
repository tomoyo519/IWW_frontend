import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  LocalStorage._internal();
  static final _instance = LocalStorage._internal();
  static LocalStorage get instance => _instance;

  static final _storage = FlutterSecureStorage();

  // =============== //
  //     KeyStore    //
  // =============== //
  // Save in secured storage
  static Future<void> saveKey(String key, String value) async {
    await _storage.write(key: key, value: value);
    LOG.log("Save {$key: $value} in secured storage.");
  }

  // Read from secured storage
  static Future<String?> readKey(String key) async {
    final value = await _storage.read(key: key);
    return value;
  }

  // Clear secured storage
  static Future<void> clearKey() async {
    await _storage.deleteAll();
  }

  // Delete key
  static Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }

  // =============== //
  //      Files      //
  // =============== //
  static Future<File> read(String path) async {
    var filepath = await _getPath(path);
    return File(filepath);
  }

  static Future<bool> delete(String path) async {
    var filepath = await _getPath(path);

    final file = File(filepath);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }

  static Future<String?> saveFromUrl(String url, String path) async {
    // 네트워크에서 이미지 데이터 가져오기
    var response = await http.get(Uri.parse(url));
    var bytes = response.bodyBytes;
    var filepath = await _getPath(path);

    // 파일에 쓰기
    File file = File(filepath);
    await file.writeAsBytes(bytes);

    return filepath;
  }

  static Future<String> _getPath(String path) async {
    // 저장할 로컬 파일 경로
    var dir = await getApplicationDocumentsDirectory();
    final storage = Directory('${dir.path}/assets');

    // 디렉토리 없으면 만들기
    if (!await storage.exists()) {
      await storage.create(recursive: true);
    }
    return '${storage.path}/$path';
  }
}
