import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/landing.dart';
import 'package:flutter/services.dart';
import 'package:QuizzedGame/locator.dart';

void main() {
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  ////

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzed Game',
      theme: ThemeData(
        fontFamily: 'Airbnb',
      ),
      home: Landing(),
    );
  }
}
