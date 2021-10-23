import 'dart:convert';

import 'package:ggez/Pages/Models/model_createroom_resp.dart';

class API {
  static const String wsUrl = "ws://127.0.0.1:8000";

  static String createRoomRequest(
      {String displayName = "random Nameless DUDE"}) {
    String name = "random Nameless DUDE";
    if (displayName.isNotEmpty) {
      name = displayName;
    }

    return jsonEncode({
      "action": "createRoom",
      "userName": name,
    });
  }

  ///Returns map in this format
  ///{status code : -1 , roomNumber : roomNumberFake , userName : fakeUserName}
  static ModelCreateRoomResp parseCreateRoomRequestResponse(String response) {
    var parsedData = jsonDecode(response);
    final int statusCode = parsedData['status code'] as int;
    final int roomNumber = parsedData['roomNumber'] as int;
    final String userName = parsedData['userName'];
    ModelCreateRoomResp modelCreateRoomResp =
        ModelCreateRoomResp(userName, roomNumber, statusCode);
    return modelCreateRoomResp;
  }

  static String createSendMessageRequest(String message) {
    return jsonEncode({"action": "message", "message": message});
  }
}
