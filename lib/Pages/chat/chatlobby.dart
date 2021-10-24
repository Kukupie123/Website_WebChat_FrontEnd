// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/Models/model_response.dart';
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
    return Scaffold(
        body: Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(getConnectedUsers().length, (index) {
              if (index == 0) {
                return Text(
                    "Users in lobby : " + getConnectedUsers()[index] + ", ");
              } else if (index == (getConnectedUsers().length - 1)) {
                return Text(getConnectedUsers()[index]);
              } else {
                return Text(getConnectedUsers()[index] + ", ");
              }
            }),
          ),
        ),
        Row(
          children: [
            Text("Room Number : " + widget.roomNumber.toString()),
            Text("Display Name : " + widget.userName.toString())
          ],
        ),
        TextFormField(
          controller: messageTC,
          decoration: InputDecoration(hintText: "Message"),
          onChanged: (value) {
            Provider.of<MainProvider>(context, listen: false)
                .sendData(API.getCreateSendMessageRequest(messageTC!.text));
          },
        ),
        StreamBuilder(
          builder: (context, snapshot) {
            bool hasData = false;
            if (snapshot.data != null) {
              if (snapshot.hasData) {
                hasData = true;
              }
            }

            if (hasData) {
              var respMapped = ModelParser.getCorrect(snapshot.data.toString());
              if (respMapped!.containsKey(ResponseEventType.MessageEvent)) {
                if (respMapped[ResponseEventType.MessageEvent] != null) {
                  var messageRespModel =
                      respMapped[ResponseEventType.MessageEvent]
                          as ModelMessageResp;
                  return Text(messageRespModel.sender +
                      " : " +
                      messageRespModel.message);
                } else {
                  return Text("xxxxx");
                }
              } else {
                return Text("Stoxx");
              }
            } else {
              return Text(".....");
            }
          },
          stream: Provider.of<MainProvider>(context, listen: false)
              .getStream()!
              .stream,
        ),
      ],
    ));
  }

  List<String> getConnectedUsers() {
    var list = <String>["test user", 'test user 2', 'third user'];
    return list;
  }
}
