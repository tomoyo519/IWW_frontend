import 'dart:convert';
import 'dart:developer';

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
  // 연락처 접근 권한이 허용되었는지 여부
  Future<bool> get isContactGranted async {
    if (await Permission.contacts.isDenied) {
      return Permission.contacts.request().isGranted;
    }
    return true;
  }

  // 네트워크가 연결되었는지 여부
  Future<bool> get isNetworkConnected async {
    // TODO: Not implemented
    return true;
  }

  // 연락처를 기준으로 서버에서 유저를 찾아 반환 (유저 아이디만)
  Future<List<Contact>?> get contacts async {
    if (await isContactGranted) {
      List<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        // log("${contact.displayName}");
      }
      return contacts;
    } else {
      return null;
    }
  }

  addFriend() async {
    // TODO: Not implemented
  }
}
