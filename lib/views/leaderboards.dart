import 'package:flutter/material.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class Leaderboards extends StatefulWidget {
  final String userUID;
  final String lang;
  Leaderboards({Key key, @required this.lang, @required this.userUID})
      : super(key: key);

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  bool isLoading = false;
  String userUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Text('Leaderboards'),
        ),
      ),
      bottomNavigationBar: buildConvexAppBar(
        context,
        1,
        widget.userUID,
        widget.lang,
      ),
    );
  }
}
