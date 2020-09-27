import 'dart:async';
import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/views/signup.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  final String lang;
  SignIn({Key key, @required this.lang}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final authentificationService = locator.get<AuthentificationService>();
  String email, password;

  bool isLoading = false;
  String userUID;

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authentificationService.signIn(email, password).then(
        (value) {
          if (value != null) {
            print('Sign In UID: ' + value.uid + '  -------------');

            Future.delayed(
              Duration(milliseconds: 200),
              () {
                Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (BuildContext context, _, __) {
                      return Home(
                        userUID: value.uid,
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
            );
          }
          if (value == null) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('Signin/first'),
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                ),
                content: Text(
                  AppLocalizations.of(context).translate('Signin/second'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('Signin/third'),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/appBar.png'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty
                              ? AppLocalizations.of(context)
                                  .translate('Signin/fourth')
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('Signin/fifth'),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          return value.isEmpty
                              ? AppLocalizations.of(context)
                                  .translate('Signin/sixth')
                              : null;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('Signin/seventh'),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: RaisedButton(
                          onPressed: () {
                            signIn();
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Signin/eighth'),
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Signin/ninth'),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                new PageRouteBuilder(
                                  pageBuilder: (BuildContext context, _, __) {
                                    return SignUp(
                                      lang: widget.lang,
                                    );
                                  },
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return new FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Signin/tenth'),
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
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
