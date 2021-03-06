import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;

  DataBaseService({this.uid});

  Future<void> addQuizDataEN(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .setData(quizData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addQuizDataFR(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("QuizzFR")
        .document(quizId)
        .setData(quizData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addQuizDataAR(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("QuizzAR")
        .document(quizId)
        .setData(quizData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addQuestionDataEN(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .collection('Q&A')
        .add(questionData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addQuestionDataFR(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("QuizzFR")
        .document(quizId)
        .collection('Q&A')
        .add(questionData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addQuestionDataAR(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("QuizzAR")
        .document(quizId)
        .collection('Q&A')
        .add(questionData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  getQuizDataEN() async {
    return Firestore.instance.collection("Quizz").snapshots();
  }

  getQuizDataFR() async {
    return Firestore.instance.collection("QuizzFR").snapshots();
  }

  getQuizDataAR() async {
    return Firestore.instance.collection("QuizzAR").snapshots();
  }

  getQuizDataQuestionsEN(String quizId) async {
    return await Firestore.instance
        .collection("Quizz")
        .document(quizId)
        .collection("Q&A")
        .getDocuments();
  }

  getQuizDataQuestionsFR(String quizId) async {
    return await Firestore.instance
        .collection("QuizzFR")
        .document(quizId)
        .collection("Q&A")
        .getDocuments();
  }

  getQuizDataQuestionsAR(String quizId) async {
    return await Firestore.instance
        .collection("QuizzAR")
        .document(quizId)
        .collection("Q&A")
        .getDocuments();
  }

  Future getUserData(String userId) async {
    return await Firestore.instance.collection("Users").document(userId).get();
  }

  Future updateUserData(
    String userId,
    String uploadedFileURL,
    String fullName,
    String userEmail,
    String password,
    String age,
  ) async {
    return await Firestore.instance
        .collection("Users")
        .document(userId)
        .setData(
      {
        'userId': userId,
        'uploadedFileURL': uploadedFileURL,
        'FullName': fullName,
        'userEmail': userEmail,
        'password': password,
        'age': age,
      },
    );
  }

  getUserHistory(String userID) async {
    return await Firestore.instance
        .collection("Users")
        .document(userID)
        .collection("History")
        .getDocuments();
  }

  setUserHistory(String userID, Map quizResault) async {
    return await Firestore.instance
        .collection("Users")
        .document(userID)
        .collection("History")
        .add(quizResault)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  Future<void> addLeaderboardsData(
      Map leaderboardsData, String quizTitle, Map quizData) async {
    await Firestore.instance
        .collection("Leaderboards")
        .document(quizTitle)
        .setData(quizData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );

    await Firestore.instance
        .collection('Leaderboards')
        .document(quizTitle)
        .collection('HighScore')
        .add(leaderboardsData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  getLeaderboardsDocuments() async {
    return Firestore.instance.collection("Leaderboards").snapshots();
  }

  getLeaderboardsData(String quizTitle) async {
    return await Firestore.instance
        .collection('Leaderboards')
        .document(quizTitle)
        .collection('HighScore')
        .getDocuments();
  }

  getLeaderboards() async {
    return Firestore.instance.collection('Leaderboards').snapshots();
  }

  Future<void> addBug(Map bugData, String userId) async {
    await Firestore.instance
        .collection("Bugs")
        .document(userId)
        .collection('Bugs')
        .add(bugData)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }
}
