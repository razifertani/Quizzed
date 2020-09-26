import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/playQuiz.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:QuizzedGame/views/create.dart';
import 'dart:async';

class Home extends StatefulWidget {
  final String userUID;
  final String lang;
  Home({Key key, @required this.userUID, @required this.lang})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  final dataBaseService = locator.get<DataBaseService>();
  final authentificationService = locator.get<AuthentificationService>();
  bool isLoading = true;

  @override
  void initState() {
    print('Home UID: ' + widget.userUID + '  ******************');

    if (widget.lang == 'en') {
      dataBaseService.getQuizDataEN().then((value) {
        setState(() {
          quizStream = value;
        });
      });
    } else if (widget.lang == 'fr') {
      dataBaseService.getQuizDataFR().then((value) {
        setState(() {
          quizStream = value;
        });
      });
    } else if (widget.lang == 'ar') {
      dataBaseService.getQuizDataAR().then((value) {
        setState(() {
          quizStream = value;
        });
      });
    } else {
      dataBaseService.getQuizDataEN().then((value) {
        setState(() {
          quizStream = value;
        });
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

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapchot) {
          return snapchot.data == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  itemCount: snapchot.data.documents.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      quizId: snapchot.data.documents[index].data['quizzId'],
                      imageURL:
                          snapchot.data.documents[index].data['quizzImageUrl'],
                      title: snapchot.data.documents[index].data['quizzTitle'],
                      description: snapchot
                          .data.documents[index].data['quizzDescription'],
                      userUID: widget.userUID,
                      lang: widget.lang,
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/appBar.png'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 30.0,
              color: Colors.blue,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: Center(
                    child: new Text(
                      AppLocalizations.of(context).translate('Home/first'),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  content: new Text(
                    AppLocalizations.of(context).translate('Home/second'),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        AppLocalizations.of(context).translate('Home/third'),
                      ),
                      onPressed: () {
                        authentificationService.signOut();
                        Navigator.of(context).push(
                          new PageRouteBuilder(
                            pageBuilder: (BuildContext context, _, __) {
                              return SignIn(
                                lang: widget.lang,
                              );
                            },
                            transitionsBuilder: (_, Animation<double> animation,
                                __, Widget child) {
                              return new FadeTransition(
                                  opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                    ),
                    FlatButton(
                      child: Text(
                        AppLocalizations.of(context).translate('Home/fourth'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading ? waiting() : quizList(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       new PageRouteBuilder(
      //         pageBuilder: (BuildContext context, _, __) {
      //           return Create(
      //             userUID: widget.userUID,
      //             lang: widget.lang,
      //           );
      //         },
      //         transitionsBuilder:
      //             (_, Animation<double> animation, __, Widget child) {
      //           return new FadeTransition(opacity: animation, child: child);
      //         },
      //       ),
      //     );
      //   },
      // ),
      bottomNavigationBar: buildConvexAppBar(
        context,
        2,
        widget.userUID,
        widget.lang,
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String userUID;
  final String lang;
  final String imageURL;
  final String title;
  final String description;
  final String quizId;

  QuizTile({
    @required this.userUID,
    @required this.imageURL,
    @required this.title,
    @required this.description,
    @required this.quizId,
    @required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return PlayQuiz(
                quizId: quizId,
                quizTitle: title,
                userUID: userUID,
                imageURL: imageURL,
                lang: lang,
              );
            },
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        height: MediaQuery.of(context).size.height * 0.26,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageURL,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.fitWidth),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
