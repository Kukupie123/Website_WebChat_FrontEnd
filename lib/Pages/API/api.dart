import 'dart:convert';

class AWSAPI {
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
}

/*
Notes
Request body for creating room
 */
