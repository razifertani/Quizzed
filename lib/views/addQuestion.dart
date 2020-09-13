import 'package:QuizzedGame/locator.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String userUID;
  final String quizId;
  AddQuestion({Key key, this.quizId, this.userUID}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  final dataBaseService = locator.get<DataBaseService>();
  String imageURL, question, correctanswer, option1, option2, option3;
  bool _isLoading = false;

  uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "imageURL": imageURL,
        "question": question,
        "correctanswer": correctanswer,
        "option1": option1,
        "option2": option2,
        "option3": option3,
      };

      dataBaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        imageURL = "";
        question = "";
        correctanswer = "";
        option1 = "";
        option2 = "";
        option3 = "";

        setState(() {
          _isLoading = false;
        });
      });
    }
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
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          return value.length == 1
                              ? "Enter an image URL !"
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Image URL',
                        ),
                        onChanged: (value) {
                          imageURL = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Enter a question !" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Question',
                        ),
                        onChanged: (value) {
                          question = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty
                              ? "Enter the correct answer !"
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Correct answer',
                        ),
                        onChanged: (value) {
                          correctanswer = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Enter an option !" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Option',
                        ),
                        onChanged: (value) {
                          option1 = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Enter an option !" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Option',
                        ),
                        onChanged: (value) {
                          option2 = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Enter an option !" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Option',
                        ),
                        onChanged: (value) {
                          option3 = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              uploadQuizData();
                            },
                            child: blueButton(
                              context,
                              'Add question',
                              MediaQuery.of(context).size.width * 0.4,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: Center(
                                    child: new Text(
                                      "Success",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 25),
                                    ),
                                  ),
                                  content: new Text(
                                    "Quiz added successfully !",
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          new PageRouteBuilder(
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return Home(
                                                userUID: widget.userUID,
                                              );
                                            },
                                            transitionsBuilder: (_,
                                                Animation<double> animation,
                                                __,
                                                Widget child) {
                                              return new FadeTransition(
                                                  opacity: animation,
                                                  child: child);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                            child: blueButton(
                              context,
                              'Submit',
                              MediaQuery.of(context).size.width * 0.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
