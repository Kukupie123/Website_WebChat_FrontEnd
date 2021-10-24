// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/Models/model_response.dart';
import 'package:ggez/Pages/chat/chatlobby.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:provider/provider.dart';

class PageRealTime extends StatefulWidget {
  const PageRealTime({Key? key}) : super(key: key);

  @override
  _PageRealTimeState createState() => _PageRealTimeState();
}

class _PageRealTimeState extends State<PageRealTime> {
  TextEditingController? displaynameController;
  TextEditingController? roomNumberController;

  //to allow multi page stream we need to broadcast

  //for navigation
  var roomNumber = -1;
  String userName = '';

  @override
  void initState() {
    super.initState();
    displaynameController = TextEditingController();
    roomNumberController = TextEditingController();
    Provider.of<MainProvider>(context, listen: false).connect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //sending the data to get parsed and send us a Map<event,ModelResponse> accordingly
            var resp = ModelParser.getCorrect(snapshot.data.toString());

            //Checking if the response we got is of CreateRoomEvent
            if (resp!.containsKey(ResponseEventType.CreateRoomEvent)) {
              if (resp[ResponseEventType.CreateRoomEvent] != null) {
                var responseModel = resp[ResponseEventType.CreateRoomEvent]
                    as ModelCreateRoomResp;

                if (responseModel.statusCode == 200) {
                  roomNumber = responseModel.roomNumber;
                  userName = responseModel.userName;
                  _startNavigation();
                  return Text("Loading");
                }
                return Text("Error loading");
              }
              //Checking if the response we ot is of JoinRoom
            } else if (resp!.containsKey(ResponseEventType.JoinedRoomEvent)) {
              if (resp[ResponseEventType.JoinedRoomEvent] != null) {
                var responseModel = resp[ResponseEventType.JoinedRoomEvent]
                    as ModelJoinedRoomResp;

                if (responseModel.statusCode == 200) {
                  roomNumber = responseModel.roomNumber;
                  userName = responseModel.userName;
                  _startNavigation();
                  return Text("Joining Room");
                }
                return Text("Error loading");
              }
            }
            return Text(snapshot.data.toString());
          } else {
            //MAIN VIEW WHEN WE ENTER
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: roomNumberController,
                        decoration: InputDecoration(hintText: "Room number"),
                        onChanged: (value) {
                          try {
                            int.parse(value);
                          } on Exception {
                            roomNumberController!.clear();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: displaynameController,
                        decoration: InputDecoration(hintText: "Display name"),
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () => _onJoinRoomPressed(
                        displaynameController!.text,
                        int.parse(roomNumberController!.text)),
                    child: Text("Join a room")),
                TextButton(
                    onPressed: () =>
                        _onCreateRoomPressed(displaynameController!.text),
                    child: Text("Create a new Room"))
              ],
            );
          }
        },
        stream: Provider.of<MainProvider>(context, listen: false)
            .getStream()!
            .stream,
      ),
    );
  }

  _startNavigation() async {
    await Future.delayed(Duration.zero);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PageChatLobby(roomNumber, userName),
        ),
        (route) => false);
  }

  _onCreateRoomPressed(String displayName) {
    if (displaynameController!.text.isNotEmpty) {
      Provider.of<MainProvider>(context, listen: false)
          .sendData(API.getCreateRoomRequest(displayName: displayName));
    }
  }

  _onJoinRoomPressed(String displayName, int roomNumber) {
    if (displayName.isNotEmpty && roomNumber >= 0) {
      Provider.of<MainProvider>(context, listen: false).sendData(
          API.getJoinRoomRequest(
              roomNumber: roomNumber, displayName: displayName));
    }
  }
}
