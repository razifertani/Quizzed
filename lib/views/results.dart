import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class Results extends StatefulWidget {
  final String userUID;
  final int correctAnswers, total;
  final String quizId, quizTitle, quizResult, imageURL;

  Results({
    Key key,
    @required this.correctAnswers,
    @required this.total,
    @required this.userUID,
    @required this.quizId,
    @required this.quizTitle,
    @required this.quizResult,
    @required this.imageURL,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
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
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                (widget.correctAnswers * (100) / widget.total) > 70.0
                    ? 'Congratulations ! \nYou passed the quiz'
                    : 'Unfortunately ! \nYou failed the exam',
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
                'You answered ${widget.correctAnswers} answers from ${widget.total} correctly !',
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
                    new PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) {
                        return Home(
                          userUID: widget.userUID,
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
                child: blueButton(context, 'Go to Home',
                    MediaQuery.of(context).size.height * 0.3),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Text(
                (widget.correctAnswers * (100) / widget.total) > 70.0
                    ? ''
                    : 'You can retake the quiz at any time\nHope you pass it next time !',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
