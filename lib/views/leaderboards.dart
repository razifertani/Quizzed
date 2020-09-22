import 'dart:async';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/models/user.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final dataBaseService = locator.get<DataBaseService>();
  QuerySnapshot quizSnapshot;
  bool isLoading = true;
  String userUID, quizID;
  List<String> quizTitles = [
    'Countries Flags',
    'UEFA Champions League',
    'Countries & Capitals',
    'Africa',
    'Tunisia',
  ];

  List<QuerySnapshot> quizSnapshots = [];
  User bestUser;

  @override
  void initState() {
    for (var i = 0; i < quizTitles.length; i++) {
      dataBaseService.getLeaderboardsData(quizTitles[i]).then((value) {
        quizSnapshots.add(value);
      });
    }
    super.initState();
  }

  waiting() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  leaderboardsList(int index) {
    List<User> topUsers = [];
    for (int i = 0; i < quizSnapshots[index].documents.length; i++) {
      User user = new User();
      user.uid = quizSnapshots[index].documents[i].data["userId"];
      user.result = quizSnapshots[index].documents[i].data["result"];
      if (user.uid != null) {
        topUsers.add(user);
      }
    }
    return Row(
      children: [
        QuizCard(
          title: quizTitles[index],
          topUsers: topUsers,
        ),
      ],
    );
  }

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
      body: isLoading
          ? waiting()
          : ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0),
              children: List.generate(quizTitles.length, (index) {
                return leaderboardsList(index);
              }),
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

class QuizCard extends StatefulWidget {
  final String title;
  final List topUsers;

  QuizCard({
    Key key,
    @required this.title,
    @required this.topUsers,
  }) : super(key: key);

  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 260.0,
                    height: 260.0,
                    child: Image.network(
                        'https://cdn.jpegmini.com/user/images/slider_puffin_jpegmini_mobile.jpg'),
                  )),
              new Container(
                width: 260.0,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title),
                    for (int j = 0; j < widget.topUsers.length; j++)
                      Text(widget.topUsers[j].uid),
                    for (int j = 0; j < widget.topUsers.length; j++)
                      Text(widget.topUsers[j].result),
                  ],
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ));
  }
}
