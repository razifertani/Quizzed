import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:share/share.dart';
import 'package:string_validator/string_validator.dart';

class Results extends StatefulWidget {
  final String userUID;
  final int correctAnswers, total;
  final String quizId, quizTitle, quizResult, imageURL;
  final String lang;

  Results({
    Key key,
    @required this.correctAnswers,
    @required this.total,
    @required this.userUID,
    @required this.quizId,
    @required this.quizTitle,
    @required this.quizResult,
    @required this.imageURL,
    @required this.lang,
  }) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final dataBaseService = locator.get<DataBaseService>();
  bool isLoading = true;
  DocumentSnapshot user;
  String fullName, uploadedFileURL;
  String quizTitle;

  @override
  void initState() {
    dataBaseService.getUserData(widget.userUID).then((value) {
      user = value;
      uploadedFileURL = user.data['uploadedFileURL'];
      fullName = user.data['FullName'];

      if (toDouble(widget.quizResult) > 69.0) {
        if (widget.quizTitle == 'Africa' || widget.quizTitle == 'Afrique')
          quizTitle = 'Africa';
        if (widget.quizTitle == 'Countries & Capitals' ||
            widget.quizTitle == 'Pays et Capitales')
          quizTitle = 'Countries & Capitals';
        if (widget.quizTitle == 'UEFA Champions League' ||
            widget.quizTitle == 'UEFA Ligue des Champions')
          quizTitle = 'UEFA Champions League';
        if (widget.quizTitle == 'Tunisia' || widget.quizTitle == 'Tunisie')
          quizTitle = 'Tunisia';
        if (widget.quizTitle == 'Countries Flags' ||
            widget.quizTitle == 'Drapeaux des pays')
          quizTitle = 'Countries Flags';

        Map<String, dynamic> questionMap = {
          "userId": widget.userUID,
          "userFullName": fullName,
          "userImage": uploadedFileURL,
          "result": widget.quizResult,
        };

        Map<String, String> quizData = {
          "quizTitle": quizTitle,
          "quizImage": widget.imageURL,
        };
        dataBaseService.addLeaderboardsData(questionMap, quizTitle, quizData);
      }
    });

    Map<String, dynamic> quizResultMap = {
      "quizzId": widget.quizId,
      "quizzTitle": widget.quizTitle,
      "quizzResult": widget.quizResult,
      "quizzImage": widget.imageURL,
      "quizzPassed": ((widget.correctAnswers * (100)) / widget.total) > 70.0
          ? true
          : false,
    };

    dataBaseService.setUserHistory(widget.userUID, quizResultMap);

    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    String message = AppLocalizations.of(context).translate('results/eighth') +
        widget.quizTitle +
        AppLocalizations.of(context).translate('results/ninth') +
        widget.quizResult +
        AppLocalizations.of(context).translate('results/tenth');
    Share.share(message,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      '${widget.correctAnswers * (100) / widget.total}',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 40,
                        color:
                            widget.correctAnswers * (100) / widget.total > 70.0
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      fontSize: 40,
                      color: widget.correctAnswers * (100) / widget.total > 70.0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  (widget.correctAnswers * (100) / widget.total) > 70.0
                      ? AppLocalizations.of(context).translate('results/first')
                      : AppLocalizations.of(context)
                          .translate('results/second'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: (widget.correctAnswers * (100) / widget.total) > 70.0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                AppLocalizations.of(context).translate('results/third') +
                    '${widget.correctAnswers}' +
                    AppLocalizations.of(context).translate('results/fourth') +
                    '${widget.total}' +
                    AppLocalizations.of(context).translate('results/fifth'),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.09,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, _, __) {
                          return Home(
                            userUID: widget.userUID,
                            lang: widget.lang,
                          );
                        },
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return new FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('results/sixth'),
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Text(
                (widget.correctAnswers * (100) / widget.total) > 70.0
                    ? ''
                    : AppLocalizations.of(context).translate('results/seventh'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.share),
        onPressed: () {
          share(context);
        },
      ),
    );
  }
}
