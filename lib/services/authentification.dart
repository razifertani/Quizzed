import 'package:QuizzedGame/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:QuizzedGame/models/user.dart';

class AuthentificationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DataBaseService dataBaseService = DataBaseService();
  String userUID;

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;

      await DataBaseService(uid: firebaseUser.uid).updateUserData(
          firebaseUser.uid,
          firebaseUser.email,
          'firebaseUser.password',
          'firebaseUser.age');

      return _userFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp(String email, String password, String age) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;

      getCurrentUID().then(
        (uid) {
          userUID = uid;
        },
      );

      await DataBaseService(uid: userUID)
          .updateUserData(userUID, email, password, age);

      return _userFromFirebase(firebaseUser);
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
