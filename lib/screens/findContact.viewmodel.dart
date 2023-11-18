import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// ViewModel에서 받아오는 UI 구성에 필요한 정보
class ContactDataObj {
  int id;
  String? name;
  String nickName;
  String? profileImage;

  ContactDataObj(this.id, this.name, this.nickName, this.profileImage);
}

class FindContactViewModel extends ChangeNotifier {
  // Get contacts from user device

  final List<ContactDataObj> _dummy = [
    ContactDataObj(1, "김지연", "세상만사귀찮", null),
    ContactDataObj(2, "혜린", "뿅뿅고양이", null),
    ContactDataObj(3, "정글 7기 신병철님", "미라클펄슨", null),
    ContactDataObj(4, null, "문지캠대장", null),
    ContactDataObj(5, "이현우", "whysoserious", null),
  ];

  List<ContactDataObj> get contacts => _dummy;

  // Future<void> getContacts() async {
  // 연락처를 기준으로 서버에서 유저를 찾아 반환 (유저 아이디만)
  //   if (await Permission.contacts.request().isGranted) {
  //     _contacts = await ContactsService.getContacts(withThumbnails: true);
  //   } else {
  //     // TODO: 접근 권한을 얻지 못한 경우
  //     // 메인화면으로 전환
  //   }
  // }
}
