/*
Class Objective:
A model of the responses we are going to get from the backend.
ModelBaseResp is the base Model and is private because it is of no use and making it public
will defeat the purpose of being as abstract as possible
 */

import 'dart:convert';

class _ModelBaseResp {
  final String event;

  _ModelBaseResp(this.event);
}

class ModelCreateRoomResp extends _ModelBaseResp {
  final String userName;
  final int roomNumber;
  final int statusCode;

  ModelCreateRoomResp(
      this.userName, this.roomNumber, this.statusCode, String event)
      : super(event);
}

class ModelMessageResp extends _ModelBaseResp {
  final String message;
  final String sender;

  ModelMessageResp(this.message, this.sender, String event) : super(event);
}

class ModelParser {
  static Map<ResponseEventType, _ModelBaseResp>? getCorrect(String response) {
    var data = jsonDecode(response);
    String eventType = data['event'];
    switch (eventType) {
      case "messageEvent":
        ModelMessageResp _modelMessageResp = ModelMessageResp(
            data['message'], data['senderName'], data['event']);
        return {ResponseEventType.MessageEvent: _modelMessageResp};
      case "createRoomEvent":
        ModelCreateRoomResp _modelCreateRoomResp = ModelCreateRoomResp(
            data['userName'],
            data["roomNumber"],
            data["statusCode"],
            data["event"]);
        return {ResponseEventType.CreateRoomEvent: _modelCreateRoomResp};
      case "joinedRoomEvent":
        return null;
    }
  }
}

enum ResponseEventType { MessageEvent, CreateRoomEvent, JoinedRoomEvent }
