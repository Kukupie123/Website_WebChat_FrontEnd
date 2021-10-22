// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/chat/chatlobby.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:provider/provider.dart';

class PageRealTime extends StatefulWidget {
  const PageRealTime({Key? key}) : super(key: key);

  @override
  _PageRealTimeState createState() => _PageRealTimeState();
}

class _PageRealTimeState extends State<PageRealTime> {
  TextEditingController? displayname;

  //for navigation
  bool navigate = false;
  int roomNumber = -1;
  String userName = '';

  @override
  void initState() {
    super.initState();
    displayname = TextEditingController();
    Provider.of<MainProvider>(context, listen: false).connect();
    Provider.of<MainProvider>(context, listen: false)
        .getStream()
        .listen((data) {
      print("NOTOSNDOAKSNd");
    });
  }

  @override
  void dispose() {
    Provider.of<MainProvider>(context, listen: false).closeWS();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        TextField(
          decoration: InputDecoration(hintText: "Room ID to connect to"),
        ),
        TextButton(onPressed: () {}, child: Text("Join room")),
        TextField(
          controller: displayname,
          decoration: InputDecoration(hintText: "Display name"),
        ),
        TextButton(
            onPressed: () {
              Provider.of<MainProvider>(context, listen: false).sendData(
                  AWSAPI.createRoomRequest(displayName: displayname!.text));
            },
            child: Text("Create Room and join")),
      ],
    ));
  }
}
