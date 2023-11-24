import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  LocalStorage._internal();
  static final _instance = LocalStorage._internal();
  static LocalStorage get instance => _instance;

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
