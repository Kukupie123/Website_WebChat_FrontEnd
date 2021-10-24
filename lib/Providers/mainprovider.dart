// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainProvider with ChangeNotifier {
  WebSocketChannel? _ws;
  StreamController? wssc;

  void connect({int roomID = -1}) async {
    _ws = WebSocketChannel.connect(Uri.parse(API.wsUrl));

    wssc = StreamController.broadcast();

    wssc!.addStream(_ws!.stream);
  }

  void sendData(var data) {
    _ws!.sink.add(data);
  }

  StreamController? getStream() {
    return wssc;
  }

  void closeWS() {
    _ws!.sink.close();
  }
}
