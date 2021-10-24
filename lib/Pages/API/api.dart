import 'dart:convert';

class API {
  static const String wsUrl = "ws://127.0.0.1:8000";

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

  static String getGetUsersInRoomRequest() {
    return jsonEncode({
      "action": "getConnectedUsers",
    });
  }

  static String getCreateSendMessageRequest(String message) {
    return jsonEncode({"action": "message", "message": message});
  }
}
