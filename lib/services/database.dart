import 'package:cloud_firestore/cloud_firestore.dart';

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
        print(e.toString());
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
        print(e.toString());
      },
    );
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

  Future getUserData(String userId) async {
    return await Firestore.instance.collection("Users").document(userId).get();
  }

  Future updateUserData(
    String userId,
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
}
