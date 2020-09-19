import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final dataBaseService = locator.get<DataBaseService>();
  String userUID;

  Future<String> getCurrentUID() async {
    return (await auth.currentUser()).uid;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      print('Firebase UID: ' + authResult.user.uid + '  /////////////////');

      return authResult.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp(String email, String password, String age) async {
    try {
      AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      dataBaseService.updateUserData(
          authResult.user.uid, 'null', 'null', email, password, age);

      return authResult.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserPassword(String password) async {
    try {
      var firebaseUser = await auth.currentUser();
      firebaseUser.updatePassword(password);
    } catch (e) {
      print(e.toString());
    }
  }
}
