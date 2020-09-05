import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzed',
      theme: ThemeData(
        fontFamily: 'Airbnb',
      ),
      home: Landing(),
    );
  }
}
