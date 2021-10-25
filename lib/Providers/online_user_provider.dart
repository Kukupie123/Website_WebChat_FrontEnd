import 'package:flutter/material.dart';

class OnlineUserProvider with ChangeNotifier {
  List<String> _joinedUsers = [];

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
