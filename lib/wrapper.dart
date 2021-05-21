import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth_service.dart';
import 'package:todo_app/login_page.dart';
import 'package:todo_app/main_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    AuthService.signOut();
    if (firebaseUser == null) {
      return LoginPage();
    } else {
      return MainPage();
    }
  }
}
