import 'package:flutter/material.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class Settings extends StatefulWidget {
  final String userUID;
  final String lang;
  Settings({Key key, @required this.lang, @required this.userUID})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoading = false;
  String userUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/appBar.png'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Text('Settings'),
        ),
      ),
      bottomNavigationBar: buildConvexAppBar(
        context,
        4,
        widget.userUID,
        widget.lang,
      ),
    );
  }
}
