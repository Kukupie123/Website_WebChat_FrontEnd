// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/Models/model_response.dart';
import 'package:ggez/Pages/chat/chatlobby.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:ggez/Widgets/background/animated_background.dart';
import 'package:provider/provider.dart';

class PageChatHome extends StatefulWidget {
  const PageChatHome({Key? key}) : super(key: key);

  @override
  _PageChatHomeState createState() => _PageChatHomeState();
}

class _PageChatHomeState extends State<PageChatHome> {
  TextEditingController? displaynameController;
  TextEditingController? roomNumberController;

  var roomNumber = -1; //Created or Joined room number
  String userName = ''; //Created user name

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
      body: GradientAnimated(
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //sending the data to get parsed and send us a Map<event,ModelResponse> accordingly
              var resp =
                  ModelParser.getCorrectResponseModel(snapshot.data.toString());

              //Checking if the response we got is of CreateRoomEvent
              if (resp!.containsKey(ResponseEventType.CreateRoomEvent)) {
                if (resp[ResponseEventType.CreateRoomEvent] != null) {
                  var responseModel = resp[ResponseEventType.CreateRoomEvent]
                      as ModelCreateRoomResp;

                  if (ModelParser.isModelValid(
                      ResponseEventType.CreateRoomEvent,
                      snapshot.data.toString())) {
                    roomNumber = responseModel.roomNumber;
                    userName = responseModel.userName;
                    _startNavigation();
                    return Text("Loading");
                  }
                  return Text("Error loading");
                }
                //Checking if the response we get is of JoinRoom
              } else if (resp.containsKey(ResponseEventType.JoinedRoomEvent)) {
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
                return Text("joined room model is null");
              }

              //If none of the response is what we want we are going to show the data itself
              return Text(snapshot.data.toString());
            } else {
              //MAIN VIEW WHEN WE ENTER
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Kuku's Talk It Out v1",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    backgroundBlendMode: BlendMode.softLight,
                                    color: Colors.white24,
                                  ),
                                  child: SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: roomNumberController,
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintText: "Room number"),
                                      onChanged: (value) {
                                        try {
                                          int.parse(value);
                                        } on Exception {
                                          roomNumberController!.clear();
                                        }
                                      },
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    backgroundBlendMode: BlendMode.luminosity,
                                    color: Colors.blueGrey,
                                  ),
                                  child: SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: displaynameController,
                                      decoration: InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          hintText: "Display Name"),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: DarkButtton(
                              onPressed: () => _onJoinRoomPressed(
                                  displaynameController!.text,
                                  int.parse(roomNumberController!.text)),
                              title: "Join a room")),
                      DarkButtton(
                        onPressed: () =>
                            _onCreateRoomPressed(displaynameController!.text),
                        title: "Create Room",
                      ),
                    ],
                  ),
                ],
              );
            }
          },
          stream: Provider.of<MainProvider>(context, listen: false)
              .getStream()!
              .stream,
        ),
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
