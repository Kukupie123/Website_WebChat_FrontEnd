// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:ggez/Pages/API/api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainProvider with ChangeNotifier {
  WebSocketChannel? _ws;

  void connect({int roomID = -1}) async {
    _ws = WebSocketChannel.connect(Uri.parse(API.wsUrl));
  }

  void sendData(var data) {
    _ws!.sink.add(data);
  }

  Stream getStream() {
    return _ws!.stream;
  }

  void closeWS() {
    _ws!.sink.close();
  }
}
