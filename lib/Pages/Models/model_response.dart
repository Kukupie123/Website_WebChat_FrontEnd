// ignore_for_file: constant_identifier_names

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

class ModelDisconnected extends _ModelBaseResp {
  final String userName;
  final int roomNumber;
  final int statusCode;

  ModelDisconnected(
      this.userName, this.roomNumber, this.statusCode, String event)
      : super(event);
}

class ModelCreateRoomResp extends _ModelBaseResp {
  final String userName;
  final int roomNumber;
  final int statusCode;

  ModelCreateRoomResp(
      this.userName, this.roomNumber, this.statusCode, String event)
      : super(event);
}

class ModelJoinedRoomResp extends _ModelBaseResp {
  final String userName;
  final int roomNumber;
  final int statusCode;

  ModelJoinedRoomResp(
      this.userName, this.roomNumber, this.statusCode, String event)
      : super(event);
}

class ModelMessageResp extends _ModelBaseResp {
  final String message;
  final String sender;

  ModelMessageResp(this.message, this.sender, String event) : super(event);
}

class ModelGetUsersInRoomResp extends _ModelBaseResp {
  final List<_GetUsersUserModel> usersList;

  ModelGetUsersInRoomResp(this.usersList, String event) : super(event);
}

class _GetUsersUserModel {
  final String userName;

  _GetUsersUserModel(this.userName);
}

class ModelParser {
  static Map<ResponseEventType, _ModelBaseResp?>? getCorrectResponseModel(
      String response) {
    try {
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
              data["status code"],
              data["event"]);
          return {ResponseEventType.CreateRoomEvent: _modelCreateRoomResp};
        case "joinedRoomEvent":
          ModelJoinedRoomResp _modelJoinedRoomResp = ModelJoinedRoomResp(
              data['userName'],
              data['roomNumber'],
              data['status code'],
              data['event']);
          return {ResponseEventType.JoinedRoomEvent: _modelJoinedRoomResp};

        case "disconnectedEvent":
          ModelDisconnected modelDisconnected = ModelDisconnected(
              data['userName'],
              data['roomNumber'],
              data['status code'],
              data['event']);

          return {ResponseEventType.DisconnectedRoom: modelDisconnected};
        case "getConnectedUsersEvent":
          var users = data['users']; //list of users we get
          //creating new user list
          List<_GetUsersUserModel> tempUsers = [];
          //iterating response list and making new object
          for (var u in users) {
            _GetUsersUserModel user = _GetUsersUserModel(u['userName']);
            tempUsers.add(user);
          }
          //creating model object
          ModelGetUsersInRoomResp modelGetUsersInRoomResp =
              ModelGetUsersInRoomResp(tempUsers, data['event']);
          return {
            ResponseEventType.GetUsersInRoomEvent: modelGetUsersInRoomResp
          };
      }
      return {ResponseEventType.Null: null};
    } on Exception {
      return {ResponseEventType.Null: null};
    }
  }

  static bool isModelValid(
      ResponseEventType responseEventType, String response) {
    var data = jsonDecode(response); //parsed data
    switch (responseEventType) {
      case ResponseEventType.MessageEvent:
        if ((data['message'] as String).isNotEmpty &&
            (data['senderName'] as String).isNotEmpty) {
          return true;
        } else {
          return false;
        }

      case ResponseEventType.CreateRoomEvent:
        if (data['status code'] == 200) {
          return true;
        } else {
          return false;
        }

      case ResponseEventType.JoinedRoomEvent:
        if (data['status code'] == 200) {
          return true;
        } else {
          return false;
        }
      case ResponseEventType.GetUsersInRoomEvent:
        if (data['getConnectedUsersEvent'] == "getConnectedUsersEvent") {
          return true;
        } else {
          return false;
        }

      case ResponseEventType.DisconnectedRoom:
        if (data['status code'] == 200) {
          return true;
        } else {
          return false;
        }
    }
    return false;
  }
}

enum ResponseEventType {
  MessageEvent,
  CreateRoomEvent,
  JoinedRoomEvent,
  DisconnectedRoom,
  GetUsersInRoomEvent,
  Null
}
