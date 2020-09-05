import 'package:firebase_auth/firebase_auth.dart';
import 'package:QuizzedGame/models/user.dart';

class AuthentificationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
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
      return null;
    }
  }
}
