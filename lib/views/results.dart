import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

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

  @override
  void initState() {
    Map<String, dynamic> quizResultMap = {
      "quizzId": widget.quizId,
      "quizzTitle": widget.quizTitle,
      "quizzResult": widget.quizResult,
      "quizzImage": widget.imageURL,
      "quizzPassed": ((widget.correctAnswers * (100)) / widget.total) > 70.0
          ? true
          : false,
    };

    dataBaseService.setUserHistory(widget.userUID, quizResultMap).then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
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
                          color: widget.correctAnswers * (100) / widget.total >
                                  70.0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontSize: 40,
                        color:
                            widget.correctAnswers * (100) / widget.total > 70.0
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
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
                GestureDetector(
                  onTap: () {
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
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: blueButton(
                      context,
                      AppLocalizations.of(context).translate('results/sixth'),
                      MediaQuery.of(context).size.height * 0.3),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  (widget.correctAnswers * (100) / widget.total) > 70.0
                      ? ''
                      : AppLocalizations.of(context)
                          .translate('results/seventh'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
