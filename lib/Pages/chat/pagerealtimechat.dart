// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:ggez/Pages/Models/model_createroom_resp.dart';
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
          if (snapshot.data != null) {
            if (snapshot.hasData) {
              //IF DATA IS VALID
              hasData = true;
            }
          }

          if (hasData) {
            ModelCreateRoomResp createRoomResp =
                API.parseCreateRoomRequestResponse(snapshot.data.toString());
            if (createRoomResp.statusCode == 200) {
              roomNumber = createRoomResp.roomNumber;
              userName = createRoomResp.userName;
              _startNavigation();
              return Text("Loading");
            } else {
              return Text("Error loading");
            }
          } else {
            return TextButton(
                onPressed: () {
                  Provider.of<MainProvider>(context, listen: false)
                      .sendData(API.createRoomRequest(displayName: "Kuchuk"));
                },
                child: Text("No data create now"));
          }
        },
        stream: Provider.of<MainProvider>(context, listen: false).getStream(),
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
