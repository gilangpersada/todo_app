import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<User> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;
      return firebaseUser;
    } catch (e) {
      return e;
    }
  }

  static Future<User> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;

      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Stream<User> get firebaseUserStream => _auth.authStateChanges();
}
