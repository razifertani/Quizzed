import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseService {
  final String uid;

  DataBaseService({this.uid});

  Future<void> addQuizData(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .setData(quizData)
        .catchError(
      (e) {
        print(
          e.toString(),
        );
      },
    );
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .collection('Q&A')
        .add(questionData)
        .catchError(
      (e) {
        print(
          e.toString(),
        );
      },
    );
  }

  static Future saveUserLoggedInDetails({@required bool isLogged}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("ISLOGGEDIN", isLogged);
  }

  static Future<bool> getUserLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("ISLOGGEDIN");
  }

  getQuizData() async {
    return Firestore.instance.collection("Quizz").snapshots();
  }

  getQuizDataQuestions(String quizId) async {
    return await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .collection("Q&A")
        .getDocuments();
  }
}
