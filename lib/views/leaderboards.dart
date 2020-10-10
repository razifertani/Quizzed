import 'dart:async';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/models/user.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:string_validator/string_validator.dart';

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
  bool isLoading = true;
  List<String> quizTitles = [
    'Africa',
    'UEFA Champions League',
    'Tunisia',
    'Countries & Capitals',
    'Countries Flags',
  ];
  List<String> quizTitless = [];
  List<String> quizImagess = [];
  List<QuerySnapshot> quizSnapshots = [];
  List<List<Widget>> widgetsLists = [];

  waiting() {
    Timer(Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });

    for (var i = 0; i < quizTitles.length; i++)
      Firestore.instance
          .collection('Leaderboards')
          .where("quizTitle", isEqualTo: quizTitles[i])
          .snapshots()
          .listen((result) {
        result.documents.forEach((result) {
          dataBaseService
              .getLeaderboardsData(result.data['quizTitle'])
              .then((value) async {
            quizTitless.add(result.data['quizTitle']);
            quizImagess.add(result.data['quizImage']);
            await quizSnapshots.add(value);
          });
        });
      });

    Timer(Duration(seconds: 2), () async {
      for (var index = 0; index < quizTitles.length; index++) {
        await widgetsLists.add(leaderboardsList(index));
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  leaderboardsList(int index) {
    List<UserLeaderboards> topUsers = [];
    DocumentSnapshot user;
    String uploadedFileURL, fullName;
    List<Widget> widgets = [];

    for (int i = 0; i < quizSnapshots[index].documents.length; i++) {
      UserLeaderboards user = new UserLeaderboards();
      user.uid = quizSnapshots[index].documents[i].data["userId"];
      user.result = quizSnapshots[index].documents[i].data["result"];
      if (user.uid != null) {
        topUsers.add(user);
      }
    }

    topUsers.sort((a, b) {
      return toDouble(a.result).compareTo(toDouble(b.result));
    });

    for (var t = 0; t < topUsers.length / 2; t++) {
      var temp = topUsers[t];
      topUsers[t] = topUsers[topUsers.length - 1 - t];
      topUsers[topUsers.length - 1 - t] = temp;
    }

    dataBaseService.getUserData(topUsers[4].uid).then(
      (value) {
        user = value;
        uploadedFileURL = user.data['uploadedFileURL'];
        fullName = user.data['FullName'];

        widgets.insert(
          0,
          Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: 1,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '',
                    ),
                    uploadedFileURL == null || uploadedFileURL == 'null'
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://cdn.onlinewebfonts.com/svg/img_212915.png'),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(uploadedFileURL),
                          ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width > 350
                            ? MediaQuery.of(context).size.width * 0.25
                            : MediaQuery.of(context).size.width * 0.18,
                        child: Center(
                          child: Text(
                            fullName,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        topUsers[4].result + ' %',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        dataBaseService.getUserData(topUsers[3].uid).then(
          (value) {
            user = value;
            uploadedFileURL = user.data['uploadedFileURL'];
            fullName = user.data['FullName'];

            widgets.insert(
              0,
              Column(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '',
                          style: TextStyle(
                              color: Colors.purpleAccent, fontSize: 30),
                        ),
                        uploadedFileURL == null || uploadedFileURL == 'null'
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    'https://cdn.onlinewebfonts.com/svg/img_212915.png'),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(uploadedFileURL),
                              ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 350
                                ? MediaQuery.of(context).size.width * 0.25
                                : MediaQuery.of(context).size.width * 0.18,
                            child: Center(
                              child: Text(
                                fullName,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Text(
                            topUsers[3].result + ' %',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            dataBaseService.getUserData(topUsers[2].uid).then(
              (value) {
                user = value;
                uploadedFileURL = user.data['uploadedFileURL'];
                fullName = user.data['FullName'];

                widgets.insert(
                  0,
                  Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '🥉',
                              style: TextStyle(fontSize: 30),
                            ),
                            uploadedFileURL == null || uploadedFileURL == 'null'
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        'https://cdn.onlinewebfonts.com/svg/img_212915.png'),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(uploadedFileURL),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width > 350
                                    ? MediaQuery.of(context).size.width * 0.25
                                    : MediaQuery.of(context).size.width * 0.18,
                                child: Center(
                                  child: Text(
                                    fullName,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Text(
                                topUsers[2].result + ' %',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

                dataBaseService.getUserData(topUsers[1].uid).then(
                  (value) {
                    user = value;
                    uploadedFileURL = user.data['uploadedFileURL'];
                    fullName = user.data['FullName'];

                    widgets.insert(
                      0,
                      Column(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColor,
                            height: 1,
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '🥈',
                                  style: TextStyle(
                                      color: Colors.purpleAccent, fontSize: 30),
                                ),
                                uploadedFileURL == null ||
                                        uploadedFileURL == 'null'
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            'https://cdn.onlinewebfonts.com/svg/img_212915.png'),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(uploadedFileURL),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 350
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                    child: Center(
                                      child: Text(
                                        fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    topUsers[1].result + ' %',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    dataBaseService.getUserData(topUsers[0].uid).then(
                      (value) {
                        user = value;
                        uploadedFileURL = user.data['uploadedFileURL'];
                        fullName = user.data['FullName'];

                        widgets.insert(
                          0,
                          Column(
                            children: [
                              Container(
                                color: Theme.of(context).primaryColor,
                                height: 1,
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '🥇',
                                      style: TextStyle(
                                        color: Colors.purpleAccent,
                                        fontSize: 30,
                                      ),
                                    ),
                                    uploadedFileURL == null ||
                                            uploadedFileURL == 'null'
                                        ? CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                'https://cdn.onlinewebfonts.com/svg/img_212915.png'),
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(uploadedFileURL),
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    350
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                        child: Center(
                                          child: Text(
                                            fullName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        topUsers[0].result + ' %',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
    return widgets;
  }

  returnWidgets(int index) {
    return QuizCard(
      title: quizTitless[index],
      image: quizImagess[index],
      widgets: widgetsLists[index],
    );
  }

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
      body: isLoading
          ? waiting()
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.82,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20.0),
                  children: List.generate(quizTitles.length, (index) {
                    return returnWidgets(index);
                  }),
                ),
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

class QuizCard extends StatelessWidget {
  final String title;
  final String image;
  final List widgets;

  QuizCard({
    Key key,
    @required this.title,
    @required this.image,
    @required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      color: Theme.of(context).textTheme.headline2.color,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.network(
                image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Text(title,
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              for (int j = 0; j < widgets.length; j++)
                widgets[j] == null ? Container() : widgets[j],
            ],
          ),
        ],
      ),
    );
  }
}
