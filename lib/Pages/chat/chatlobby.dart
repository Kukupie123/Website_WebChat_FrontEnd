// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/Models/model_response.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:ggez/Widgets/background/animated_background.dart';
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

  List<String> joinedUsers = [];

  @override
  void initState() {
    super.initState();
    messageTC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientAnimated(
        child: Column(
          children: [
            Text("Users online :"),
            SingleChildScrollView(
              child: Row(
                children: List.generate(joinedUsers.length, (i) {
                  return Row(children: [
                    Icon(Icons.person),
                    Text(joinedUsers[i] + ", ")
                  ]);
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
                  var respMapped =
                      ModelParser.getCorrect(snapshot.data.toString());

                  //Message received event
                  if (respMapped!.containsKey(ResponseEventType.MessageEvent)) {
                    if (respMapped[ResponseEventType.MessageEvent] != null) {
                      var messageRespModel =
                          respMapped[ResponseEventType.MessageEvent]
                              as ModelMessageResp;
                      return Text(messageRespModel.sender +
                          " : " +
                          messageRespModel.message);
                    }
                    return Text("xxxxx");
                  } else if (respMapped
                      .containsKey(ResponseEventType.JoinedRoomEvent)) {
                    if (respMapped[ResponseEventType.JoinedRoomEvent] != null) {
                      _getConnectedUsers();
                    }
                    return Text("xxxxx");
                  } else if (respMapped
                      .containsKey(ResponseEventType.GetUsersInRoomEvent)) {
                    if (respMapped[ResponseEventType.JoinedRoomEvent] != null) {
                      ModelGetUsersInRoomResp modelJoinedResp =
                          respMapped[ResponseEventType.JoinedRoomEvent]
                              as ModelGetUsersInRoomResp;

                      joinedUsers.clear();

                      for (var user in modelJoinedResp.usersList) {
                        joinedUsers.add(user.userName);
                      }

                      setState(() {});
                    } else
                      return Text("xxxxx");
                  } else
                    return Text("Stoxx");
                }
                return Text(":)");
              },
              stream: Provider.of<MainProvider>(context, listen: false)
                  .getStream()!
                  .stream,
            ),
          ],
        ),
      ),
    );
  }

  _getConnectedUsers() {
    Provider.of<MainProvider>(context, listen: false)
        .sendData(API.getGetUsersInRoomRequest());
  }
}
