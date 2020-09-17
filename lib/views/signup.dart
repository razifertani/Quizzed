import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/views/home.dart';
import 'package:QuizzedGame/views/signin.dart';
import 'package:QuizzedGame/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  final String lang;
  SignUp({Key key, @required this.lang}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final authentificationService = locator.get<AuthentificationService>();

  String userUID, email, password, age;
  bool isLoading = false;

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authentificationService.signUp(email, password, age).then(
        (value) async {
          if (value != null) {
            await authentificationService.signIn(email, password).then(
              (value) {
                if (value != null) {
                  authentificationService.getCurrentUID().then(
                    (uid) {
                      print('Sign Up UID: ' + uid + '  /////////////////');

                      Future.delayed(
                        Duration(milliseconds: 200),
                        () {
                          Navigator.of(context).push(
                            new PageRouteBuilder(
                              pageBuilder: (BuildContext context, _, __) {
                                return Home(
                                  userUID: uid,
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
                      );
                    },
                  );
                }
              },
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
                        return value.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('Signup/first')
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('Signup/second'),
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
                        return value.length < 6
                            ? AppLocalizations.of(context)
                                .translate('Signup/third')
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('Signup/fourth'),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      validator: (value) {
                        return value.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('Signup/sixth')
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('Signup/seventh'),
                      ),
                      onChanged: (value) {
                        age = value;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: blueButton(
                        context,
                        AppLocalizations.of(context).translate('Signup/eighth'),
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
                          AppLocalizations.of(context)
                              .translate('Signup/ninth'),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              new PageRouteBuilder(
                                pageBuilder: (BuildContext context, _, __) {
                                  return SignIn(
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
                                .translate('Signup/tenth'),
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
