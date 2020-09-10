import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final String userUID;
  History({Key key, this.userUID}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      bottomNavigationBar: buildConvexAppBar(context, 2, widget.userUID),
    );
  }
}
