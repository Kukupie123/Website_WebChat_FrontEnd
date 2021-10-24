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
  TextEditingController? displayname;

  //to allow multi page stream we need to broadcast

  //for navigation
  var roomNumber = -1;
  String userName = '';

  @override
  void initState() {
    super.initState();
    displayname = TextEditingController();
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
          bool hasData = false;
          print(snapshot.data.toString());


          if (snapshot.hasData) {
            //sending the data to get parsed and send us a Map<event,ModelResponse> accordingly
            var resp = ModelParser.getCorrect(snapshot.data.toString());

            //Checking if the response we got is of CreateRoomEvent
            if (resp!.containsKey(ResponseEventType.CreateRoomEvent)) {
              var responseModel = resp[ResponseEventType.CreateRoomEvent]
                  as ModelCreateRoomResp;

              if (responseModel.statusCode == 200) {
                roomNumber = responseModel.roomNumber;
                userName = responseModel.userName;
                _startNavigation();
                return Text("Loading");
              } else {
                return Text("Error loading");
              }
            } else {
              return Text(snapshot.data.toString());
            }
          } else {
            return TextButton(
                onPressed: () {
                  Provider.of<MainProvider>(context, listen: false).sendData(
                      API.getCreateRoomRequest(displayName: "Kuchuk"));
                },
                child: Text("No data create now"));
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
}
