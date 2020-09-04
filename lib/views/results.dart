import 'package:flutter/material.dart';
import 'package:quizzed/views/home.dart';
import 'package:quizzed/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correctAnswers, total;
  Results({Key key, @required this.correctAnswers, @required this.total})
      : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${widget.correctAnswers * (100) / widget.total} %',
                style: TextStyle(
                  fontSize: 40,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                child: blueButton(context, 'Go to Home',
                    MediaQuery.of(context).size.height * 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
