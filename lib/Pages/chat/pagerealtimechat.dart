// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

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

  @override
  void initState() {
    displayname = TextEditingController();
    super.initState();
    Provider.of<MainProvider>(context, listen: false).connect();
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
        StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            } else {
              try {
                var resp = jsonDecode(snapshot.data.toString());
                var status = resp['status code'];
                if (status == 200) {
                  //Push on success
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PageChatLobby(resp['roomNumber'], resp['userName']),
                      ));

                  return Text("Show login page now");
                }
              } on Exception {
                try {
                  return Text(snapshot.data.toString() + " conv fail");
                } on Exception {
                  return Container();
                }
              }
              return Text(snapshot.data.toString() + " last");
            }
          },
          stream: Provider.of<MainProvider>(context, listen: false).getStream(),
        )
      ],
    ));
  }
}
