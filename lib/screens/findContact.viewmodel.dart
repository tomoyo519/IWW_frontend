import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/get-user-by-contact.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class FindContactViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final FriendRepository friendRepository;

  FindContactViewModel(this.userRepository, this.friendRepository);

  // UI State
  int _friendCnt = 0;
  int get friendCnt => _friendCnt;
  set friendCnt(int val) {
    _friendCnt = val;
    notifyListeners();
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

      return await userRepository
          .getUsersByContacts(GetUsersByContactsDto(phoneNumbers));
    }
    return [];
  }

  // 친구추가
  Future<bool> createFriend(int friendId) async {
    return await friendRepository.createFriend(friendId);
  }

  // 친구삭제
  Future<bool> deleteFriend(int friendId) async {
    return await friendRepository.deleteFriend(friendId);
  }
}
