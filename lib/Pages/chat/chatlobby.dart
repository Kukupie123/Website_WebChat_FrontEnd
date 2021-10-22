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
    messageTC = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(getConnectedUsers().length,
                  (index) => Text(getConnectedUsers()[index])),
            ),
          ),
          TextFormField(
            controller: messageTC,
            decoration: InputDecoration(hintText: "Message"),
          ),
          TextButton(
            onPressed: () {
              if (messageTC!.text.isEmpty) return;
              Provider.of<MainProvider>(context, listen: false)
                  .sendData(AWSAPI.createSendMessageRequest(messageTC!.text));
            },
            child: Text("SEND"),
          ),
          StreamBuilder(
            builder: (context, snapshot) => Text(snapshot.data.toString()),
            stream:
                Provider.of<MainProvider>(context, listen: false).getStream(),
          )
        ],
      ),
    );
  }

  List<String> getConnectedUsers() {
    var list = <String>["test user", 'test user 2', 'third user'];
    return list;
  }
}
