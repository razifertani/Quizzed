import 'dart:async';
import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/models/question.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/results.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String userUID;
  final String lang;
  final String quizId;
  final String quizTitle;
  final String imageURL;

  const PlayQuiz(
      {Key key,
      @required this.quizId,
      @required this.userUID,
      @required this.quizTitle,
      @required this.imageURL,
      @required this.lang})
      : super(key: key);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _left = 0;

class _PlayQuizState extends State<PlayQuiz>
    with SingleTickerProviderStateMixin {
  QuerySnapshot questionSnapshot;
  final dataBaseService = locator.get<DataBaseService>();
  bool isLoading = true;

  @override
  void initState() {
    if (widget.lang == 'en') {
      dataBaseService.getQuizDataQuestionsEN(widget.quizId).then((value) {
        questionSnapshot = value;
        _left = 0;
        _correct = 0;
        total = questionSnapshot.documents.length;
      });
    } else if (widget.lang == 'fr') {
      dataBaseService.getQuizDataQuestionsFR(widget.quizId).then((value) {
        questionSnapshot = value;
        _left = 0;
        _correct = 0;
        total = questionSnapshot.documents.length;
      });
    } else if (widget.lang == 'ar') {
      dataBaseService.getQuizDataQuestionsAR(widget.quizId).then((value) {
        questionSnapshot = value;
        _left = 0;
        _correct = 0;
        total = questionSnapshot.documents.length;
      });
    } else {
      dataBaseService.getQuizDataQuestionsEN(widget.quizId).then((value) {
        questionSnapshot = value;
        _left = 0;
        _correct = 0;
        total = questionSnapshot.documents.length;
      });
    }
    super.initState();
  }

  Question getQuestionModelFromDatasnapshot(DocumentSnapshot questionSnapshot) {
    Question questionModel = new Question();

    questionModel.question = questionSnapshot.data["question"];
    questionModel.imageURL = questionSnapshot.data["imageURL"];

    List<String> options = [
      questionSnapshot.data["correctanswer"],
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctAnwser = questionSnapshot.data["correctanswer"];
    questionModel.answered = false;

    return questionModel;
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
      body: isLoading
          ? waiting()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    questionSnapshot.documents.length == 0
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('playQuiz/first'),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionSnapshot.documents.length,
                            itemBuilder: (context, index) {
                              return QuizzPlay(
                                question: getQuestionModelFromDatasnapshot(
                                  questionSnapshot.documents[index],
                                ),
                                index: index,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
        ),
        onPressed: () {
          Navigator.of(context).push(
            new PageRouteBuilder(
              pageBuilder: (BuildContext context, _, __) {
                return Results(
                  correctAnswers: _correct,
                  total: total,
                  userUID: widget.userUID,
                  quizId: widget.quizId,
                  quizTitle: widget.quizTitle,
                  quizResult: '${(_correct * 100) / total}',
                  imageURL: widget.imageURL,
                  lang: widget.lang,
                );
              },
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return new FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}

class QuizzPlay extends StatefulWidget {
  final Question question;
  final int index;

  const QuizzPlay({Key key, this.question, this.index}) : super(key: key);

  @override
  _QuizzPlayState createState() => _QuizzPlayState();
}

class _QuizzPlayState extends State<QuizzPlay> {
  String optionSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Q${widget.index + 1}:  ${widget.question.question}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!widget.question.answered) {
                          if (widget.question.option1 ==
                              widget.question.correctAnwser) {
                            optionSelected = widget.question.option1;
                            widget.question.answered = true;
                            _correct = _correct + 1;
                            _left = _left - 1;
                            setState(() {});
                          } else {
                            optionSelected = widget.question.option1;
                            widget.question.answered = true;
                            _left = _left - 1;
                            setState(() {});
                          }
                        }
                      },
                      child: OptionTile(
                        correctAnswer: widget.question.correctAnwser,
                        description: widget.question.option1,
                        option: 'A',
                        optionSelected: optionSelected,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.question.answered) {
                          if (widget.question.option2 ==
                              widget.question.correctAnwser) {
                            optionSelected = widget.question.option2;
                            widget.question.answered = true;
                            _correct = _correct + 1;
                            _left = _left - 1;
                            setState(() {});
                          } else {
                            optionSelected = widget.question.option2;
                            widget.question.answered = true;
                            _left = _left - 1;
                            setState(() {});
                          }
                        }
                      },
                      child: OptionTile(
                        correctAnswer: widget.question.correctAnwser,
                        description: widget.question.option2,
                        option: 'B',
                        optionSelected: optionSelected,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.question.answered) {
                          if (widget.question.option3 ==
                              widget.question.correctAnwser) {
                            optionSelected = widget.question.option3;
                            widget.question.answered = true;
                            _correct = _correct + 1;
                            _left = _left - 1;
                            setState(() {});
                          } else {
                            optionSelected = widget.question.option3;
                            widget.question.answered = true;
                            _left = _left - 1;
                            setState(() {});
                          }
                        }
                      },
                      child: OptionTile(
                        correctAnswer: widget.question.correctAnwser,
                        description: widget.question.option3,
                        option: 'C',
                        optionSelected: optionSelected,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.question.answered) {
                          if (widget.question.option4 ==
                              widget.question.correctAnwser) {
                            optionSelected = widget.question.option4;
                            widget.question.answered = true;
                            _correct = _correct + 1;
                            _left = _left - 1;
                            setState(() {});
                          } else {
                            optionSelected = widget.question.option4;
                            widget.question.answered = true;
                            _left = _left - 1;
                            setState(() {});
                          }
                        }
                      },
                      child: OptionTile(
                        correctAnswer: widget.question.correctAnwser,
                        description: widget.question.option4,
                        option: 'D',
                        optionSelected: optionSelected,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
              widget.question.imageURL == null
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.question.imageURL == null
                                ? null
                                : widget.question.imageURL,
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
