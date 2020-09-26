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
    'Countries Flags',
    'Africa',
    'Tunisia',
    'Countries & Capitals',
    'UEFA Champions League',
  ];
  List<String> quizImages = [
    'https://kids.nationalgeographic.com/content/dam/kidsea/kids-core-objects/backgrounds/1900x1068_herolead_countries.adapt.1900.1.jpg',
    'https://greateyecare.com/images/blog/africa-2.jpg',
    'https://i.pinimg.com/originals/99/6e/80/996e8096e984f051f6da569e154c8c41.jpg',
    'https://www.riotgames.com/darkroom/1440/b2b587d91d3c5d2922953ac62fbb2cb8:dfd0d5c2d07f981fb8cda29623b5e54e/paris.jpg',
    'https://i.eurosport.com/2020/03/16/2794949-57682990-2560-1440.jpg',
  ];
  List<QuerySnapshot> quizSnapshots = [];

  @override
  void initState() {
    for (var i = 0; i < quizTitles.length; i++)
      Firestore.instance
          .collection('Leaderboards')
          .where("quizTitle", isEqualTo: quizTitles[i])
          .snapshots()
          .listen((result) {
        result.documents.forEach((result) {
          dataBaseService
              .getLeaderboardsData(result.data['quizTitle'])
              .then((value) {
            quizSnapshots.add(value);
          });
        });
      });

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
                color: Colors.blue,
                height: 1,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    uploadedFileURL == null || uploadedFileURL == 'null'
                        ? Container()
                        : CircleAvatar(
                            backgroundImage: NetworkImage(uploadedFileURL),
                          ),
                    Text('3: ' + fullName),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Text(
                        topUsers[2].result,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
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
                    color: Colors.blue,
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        uploadedFileURL == null || uploadedFileURL == 'null'
                            ? Container()
                            : CircleAvatar(
                                backgroundImage: NetworkImage(uploadedFileURL),
                              ),
                        Text('2: ' + fullName),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: Text(
                            topUsers[1].result,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
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
                        color: Colors.blue,
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
                            uploadedFileURL == null || uploadedFileURL == 'null'
                                ? Container()
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(uploadedFileURL),
                                  ),
                            Text('1:  ' + fullName),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: Text(
                                topUsers[0].result,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
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
    return QuizCard(
      title: quizTitles[index],
      image: quizImages[index],
      widgets: widgets,
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
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20.0),
                  children: List.generate(quizTitles.length, (index) {
                    return leaderboardsList(index);
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
      color: Colors.white,
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
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
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
