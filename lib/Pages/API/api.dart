import 'dart:convert';

class API {
  static const String wsUrl = "ws://127.0.0.1:8000";

  ///Returns a json body that tells the backend to create a room
  static String getCreateRoomRequest(
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

  ///Returns a json body that tells the backend to join a room
  static String getJoinRoomRequest(
      {String displayName = "Random dude joined lol",
      required int roomNumber}) {
    String name = "random Nameless DUDE";
    if (displayName.isNotEmpty) {
      name = displayName;
    }

    return jsonEncode(
        {"action": "join", "userName": name, 'roomNumber': roomNumber});
  }

  ///Returns a json body that tells the backend to get users in room
  static String getGetUsersInRoomRequest() {
    return jsonEncode({
      "action": "getConnectedUsers",
    });
  }

  ///Returns a json body that tells the backend to send message
  static String getCreateSendMessageRequest(String message) {
    return jsonEncode({"action": "message", "message": message});
  }
}
