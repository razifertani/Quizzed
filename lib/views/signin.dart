import 'dart:async';
import 'package:QuizzedGame/locator.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/views/signup.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

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
              builder: (_) => new AlertDialog(
                title: Center(
                  child: new Text(
                    "Error",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                ),
                content: new Text(
                  "Incorrect Email/Password !",
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close'),
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
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        return value.isEmpty ? "Enter a correct email !" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                        return value.isEmpty ? "Enter a password !" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: blueButton(
                        context,
                        'Sign In',
                        MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account ? ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              new PageRouteBuilder(
                                pageBuilder: (BuildContext context, _, __) {
                                  return SignUp();
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
                            "Sign Up",
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
    );
  }
}
