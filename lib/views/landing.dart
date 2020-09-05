import 'package:flutter/material.dart';
import 'dart:async';
import 'package:QuizzedGame/views/signin.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/views/home.dart';

class Landing extends StatefulWidget {
  Landing({Key key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    checkUserLogged();
    startTime();
  }

  Future checkUserLogged() async {
    DataBaseService.getUserLogged().then((value) {
      if (value = true) {
        setState(() {
          isLogged = value;
        });
      }
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => (isLogged ?? false) ? Home() : SignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 50),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Quizzed',
                      style: TextStyle(
                        fontFamily: 'Airbnb',
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: 'Game',
                      style: TextStyle(
                        fontFamily: 'Airbnb',
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(
              'Best quiz game ever',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Airbnb',
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
