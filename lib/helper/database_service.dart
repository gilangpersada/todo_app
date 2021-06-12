import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static Future<void> registerUser(String uid, String username, String email,
      String password, context) async {
    return await FirebaseFirestore.instance.collection('user').doc(uid).set({
      'username': username,
      'email': email,
      'password': password,
    });
  }

  static Future<bool> checkUsername(String username) async {
    bool result = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get()
        .then((value) async {
      if (value.docs.isEmpty && username.length > 5) {
        return true;
      } else {
        return false;
      }
    });
    return result;
  }

  static Future<bool> checkEmail(String email) async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    bool result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isEmpty && emailValid) {
        return true;
      } else {
        return false;
      }
    });
    return result;
  }

  static Future<bool> checkPassword(String password) async {
    if (password.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> loginUser() {}

  static getUserInfo(String uid) {
    return FirebaseFirestore.instance.collection('user').doc(uid);
  }
}
