import 'package:QuizzedGame/appLocalizations.dart';
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
  bool isConnected = true;
  String lang;

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
    lang = AppLocalizations.of(context).translate('lang');
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return SignIn(
            lang: lang,
          );
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
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Image.asset(
            'Assets/logo.jpg',
            fit: BoxFit.fitWidth,
          ),
        ),
        isConnected == true
            ? Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.75,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('Landing/first'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Airbnb',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('Landing/second'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
                        elevation: 15,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('Landing/third'),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    ));
  }
}
