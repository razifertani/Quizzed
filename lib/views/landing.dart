import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:QuizzedGame/views/signin.dart';

class Landing extends StatefulWidget {
  Landing({Key key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool isConnected = false;
  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  checkConnectivity() async {
    await DataConnectionChecker().hasConnection.then((value) {
      setState(() {
        isConnected = value;
        isConnected == true ? startTime() : null;
      });
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return SignIn();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isConnected == true
          ? Container(
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
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.13,
                        ),
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
            )
          : Container(
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
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.13,
                        ),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Text(
                          'No internet connection !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        RaisedButton(
                          onPressed: () {
                            checkConnectivity();
                          },
                          child: Text(
                            'TRY AGAIN',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
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
