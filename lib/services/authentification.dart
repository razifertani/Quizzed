import 'package:QuizzedGame/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DataBaseService dataBaseService = DataBaseService();
  String userUID;

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      print('Firebase User: ' + authResult.user.uid + '  /////////////////');

      return authResult.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp(String email, String password, String age) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      dataBaseService.updateUserData(
          authResult.user.uid, 'null', email, password, age);

      return authResult.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
