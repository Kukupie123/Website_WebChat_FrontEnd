// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:provider/provider.dart';

class PageChatLobby extends StatefulWidget {
  PageChatLobby(this.roomNumber, this.userName);

  final int roomNumber;
  final String userName;

  @override
  _PageChatLobbyState createState() => _PageChatLobbyState();
}

class _PageChatLobbyState extends State<PageChatLobby> {
  TextEditingController? messageTC;

  @override
  void initState() {
    super.initState();
    messageTC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Chat page"));
  }

  List<String> getConnectedUsers() {
    var list = <String>["test user", 'test user 2', 'third user'];
    return list;
  }
}
