import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<void> takePictureAndUpload() async {
  // 카메라로 사진을 찍습니다.
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    // http 요청을 생성합니다.
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://your-api-endpoint.com'));

    // 요청에 찍은 사진을 추가합니다.
    request.files
        .add(await http.MultipartFile.fromPath('picture', pickedFile.path));

    // API로 요청을 전송합니다.
    var response = await request.send();

    // 응답을 출력합니다.
    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      print('Upload failed');
    }
  } else {
    print('No image selected.');
  }
}
