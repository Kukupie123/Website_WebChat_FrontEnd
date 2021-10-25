// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class OnlineUserProvider with ChangeNotifier {
  List<String> _joinedUsers = [];

  Map<String, String> _usersTexting = <String, String>{}; //username,text
//adds new text
  void addNewText(String userName, String message) async {
    if (_usersTexting.containsKey(userName)) {
      _usersTexting[userName] = message;
    } else {
      _usersTexting.addAll({userName: message});
    }
  }

  Map<String, String> getUsersTexting() {
    return _usersTexting;
  }

  void setUsers(List<String> users) async {
    _joinedUsers.clear();
    _joinedUsers = users;

    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  List<String> getUserList() {
    return _joinedUsers;
  }
}
