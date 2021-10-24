// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ggez/Pages/chat/pagerealtimechat.dart';
import 'package:ggez/Providers/mainprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  PageRealTime(),
      ),
    );
  }
}
