import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/authentification.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  final String userUID;
  final String lang;
  Profile({Key key, @required this.userUID, @required this.lang})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showPassword = false;
  bool isLoading = true;
  DocumentSnapshot user;
  final dataBaseService = locator.get<DataBaseService>();
  final authentificationService = locator.get<AuthentificationService>();
  String uid, fullName, email, password, age, uploadedFileURL;
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
            uploadedFileURL = user.data['uploadedFileURL'];
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

  File image;
  Future chooseFile() async {
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((imagePicked) {
      setState(() {
        image = imagePicked;
      });
    });

    setState(() {
      isLoading = true;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('profile/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        uploadedFileURL = fileURL;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: buildConvexAppBar(
              context,
              0,
              widget.userUID,
              widget.lang,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Image.asset('Assets/appBar.png'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Alert(
                      context: context,
                      title: AppLocalizations.of(context)
                          .translate('Profile/first'),
                      content: Column(
                        children: <Widget>[
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: AppLocalizations.of(context)
                                  .translate('Profile/third'),
                            ),
                            onChanged: (value) {
                              oldPassword = value;
                            },
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: AppLocalizations.of(context)
                                  .translate('Profile/fourth'),
                            ),
                            onChanged: (value) {
                              newPassword = value;
                            },
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: AppLocalizations.of(context)
                                  .translate('Profile/fifth'),
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
                                uploadedFileURL,
                                fullName,
                                email,
                                newPassword,
                                age,
                              );
                              setState(() {
                                password = newPassword;
                              });
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate('Profile/sixth'),
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
                                      AppLocalizations.of(context)
                                          .translate('Profile/seventh'),
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                  ),
                                  content: new Text(
                                    AppLocalizations.of(context)
                                        .translate('Profile/eighth'),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('Profile/ninth'),
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
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Profile/tenth'),
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
                      AppLocalizations.of(context)
                          .translate('Profile/eleventh'),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
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
                                  uploadedFileURL == "null"
                                      ? 'https://cdn.onlinewebfonts.com/svg/img_212915.png'
                                      : uploadedFileURL,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.12,
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
                                padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      0.0001,
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  chooseFile();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
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
                          labelText: AppLocalizations.of(context)
                              .translate('Profile/twelfth'),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: fullName == "null"
                              ? AppLocalizations.of(context)
                                  .translate('Profile/thirteenth')
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
                          labelText: AppLocalizations.of(context)
                              .translate('Profile/fourteenth'),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '$email ' +
                              AppLocalizations.of(context)
                                  .translate('Profile/fifteenth'),
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
                          labelText: AppLocalizations.of(context)
                              .translate('Profile/sixteenth'),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: AppLocalizations.of(context)
                              .translate('Profile/seventeenth'),
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
                          labelText: AppLocalizations.of(context)
                              .translate('Profile/eighteenth'),
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
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.06,
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
                                  uploadedFileURL,
                                  fullName,
                                  email,
                                  password,
                                  age,
                                );

                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate('Profile/nineteenth'),
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
                                        AppLocalizations.of(context)
                                            .translate('Profile/seventh'),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    content: new Text(
                                      AppLocalizations.of(context)
                                          .translate('Profile/twentieth'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('Profile/ninth'),
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
                            color: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.13,
                            ),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Profile/twenty-first'),
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 2.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: buildConvexAppBar(
              context,
              0,
              widget.userUID,
              widget.lang,
            ),
          );
  }
}
