import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  final String userUID;
  Profile({Key key, this.userUID}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showPassword = false;
  bool isLoading = true;
  DocumentSnapshot user;
  final dataBaseService = locator.get<DataBaseService>();
  final authentificationService = locator.get<AuthentificationService>();
  String uid, fullName, email, password, age;
  String fullNameWritten, emailWritten, passwordWrittern, ageWritten;
  String oldPassword, newPassword, newnewPassword;

  @override
  void initState() {
    dataBaseService.getUserData(widget.userUID).then((value) {
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          user = value;
          setState(() {
            uid = user.data['userId'];
            fullName = user.data['FullName'];
            email = user.data['userEmail'];
            password = user.data['password'];
            age = user.data['age'];
            isLoading = false;
          });
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: appBar(context),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.light,
              leading: Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Alert(
                      context: context,
                      title: "RESET PASSWORD",
                      content: Column(
                        children: <Widget>[
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Old Password',
                            ),
                            onChanged: (value) {
                              oldPassword = value;
                            },
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'New Password',
                            ),
                            onChanged: (value) {
                              newPassword = value;
                            },
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Repeat New Password',
                            ),
                            onChanged: (value) {
                              newnewPassword = value;
                            },
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            if (oldPassword == password &&
                                newPassword == newnewPassword) {
                              authentificationService
                                  .updateUserPassword(newPassword);
                              dataBaseService.updateUserData(
                                uid,
                                fullName,
                                email,
                                newPassword,
                                age,
                              );
                              setState(() {
                                password = newPassword;
                              });
                              Fluttertoast.showToast(
                                msg: "Password Updated Successfully !",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                backgroundColor: Colors.black87,
                                fontSize: 16.0,
                              );
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: Center(
                                    child: new Text(
                                      "Error",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                  ),
                                  content: new Text(
                                    "An error occured !",
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
                          child: Text(
                            "RESET",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ).show();
                  },
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    /*            
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height * 0.18,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                )
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn.iconscout.com/icon/free/png-512/avatar-370-456322.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                  color: Colors.white,
                                ),
                                color: Colors.blue,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    */

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          fullNameWritten = value;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(),
                          labelText: 'Full Name',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: fullName == "null"
                              ? 'Write your full name'
                              : fullName,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          emailWritten = value;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(),
                          enabled: false,
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '$email (Uneditable)',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          passwordWrittern = value;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText:
                              'Write your password here before updating !',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          ageWritten = value;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(),
                          labelText: 'Age',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: age,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: RaisedButton(
                            onPressed: () {
                              if (passwordWrittern == password) {
                                if (fullNameWritten != null) {
                                  fullName = fullNameWritten;
                                }
                                if (emailWritten != null) {
                                  email = emailWritten;
                                }
                                if (ageWritten != null) {
                                  age = ageWritten;
                                }

                                dataBaseService.updateUserData(
                                  uid,
                                  fullName,
                                  email,
                                  password,
                                  age,
                                );

                                Fluttertoast.showToast(
                                  msg: "Updated successfully !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black87,
                                  fontSize: 16.0,
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                    title: Center(
                                      child: new Text(
                                        "Error",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    content: new Text(
                                      "Incorrect Password !",
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
                            color: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.13,
                            ),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: buildConvexAppBar(context, 0, widget.userUID),
          );
  }
}
