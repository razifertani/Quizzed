import 'package:QuizzedGame/locator.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/addQuestion.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class Create extends StatefulWidget {
  final String userUID;
  final String lang;
  Create({Key key, @required this.userUID, @required this.lang})
      : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  final dataBaseService = locator.get<DataBaseService>();
  String quizzImageURL, quizzTitle, quizzDescription, quizzId;
  bool _isLoading = false;

  createQuiz() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      quizzId = randomAlphaNumeric(16);
      Map<String, String> quizzData = {
        "quizzId": quizzId,
        "quizzImageUrl": quizzImageURL,
        "quizzTitle": quizzTitle,
        "quizzDescription": quizzDescription,
      };

      if (widget.lang == 'en') {
        await dataBaseService.addQuizDataEN(quizzData, quizzId).then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(
                  quizId: quizzId,
                  userUID: widget.userUID,
                  lang: widget.lang,
                ),
              ),
            );
          });
        });
      } else if (widget.lang == 'fr') {
        await dataBaseService.addQuizDataFR(quizzData, quizzId).then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(
                  quizId: quizzId,
                  userUID: widget.userUID,
                  lang: widget.lang,
                ),
              ),
            );
          });
        });
      } else if (widget.lang == 'ar') {
        await dataBaseService.addQuizDataAR(quizzData, quizzId).then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(
                  quizId: quizzId,
                  userUID: widget.userUID,
                  lang: widget.lang,
                ),
              ),
            );
          });
        });
      } else {
        await dataBaseService.addQuizDataAR(quizzData, quizzId).then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(
                  quizId: quizzId,
                  userUID: widget.userUID,
                  lang: widget.lang,
                ),
              ),
            );
          });
        });
      }
    }
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  userUID: widget.userUID,
                  lang: widget.lang,
                ),
              ),
            );
          },
        ),
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
                              ? "Enter a quizz image URL !"
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Quizz Image URL',
                        ),
                        onChanged: (value) {
                          quizzImageURL = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Enter a quizz title !" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Quizz Title',
                        ),
                        onChanged: (value) {
                          quizzTitle = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty
                              ? "Enter a quizz description !"
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Quizz Description',
                        ),
                        onChanged: (value) {
                          quizzDescription = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          createQuiz();
                        },
                        child: blueButton(
                          context,
                          'Proceed to questions',
                          MediaQuery.of(context).size.width * 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
