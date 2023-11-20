import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/get-user-by-contact.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

// ViewModel에서 받아오는 UI 구성에 필요한 정보
class ContactDataObj {
  int id;
  String? name;
  String nickName;
  String? profileImage;

  ContactDataObj(this.id, this.name, this.nickName, this.profileImage);
}

class CreateFreind {}

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
  Future<List<UserInfo>?> get contacts async {
    if (await Permission.contacts.request().isGranted) {
      List<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);

      // 모든 연락처의 전화번호를 단일 리스트로 평탄화
      var phoneNumbers = contacts
          .expand((contact) => contact.phones!.map((phone) => phone.value!))
          .toList();

      if (phoneNumbers.isEmpty) {
        return [];
      }

      return await UserRepository.getUsersByContacts(
          GetUsersByContactsDto(phoneNumbers));
    }
    return [];
  }

  addFriend() async {
    // TODO: Not implemented
  }
}
