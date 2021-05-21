import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var userAccount;
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    CollectionReference<Map<String, dynamic>> userDatabase =
        FirebaseFirestore.instance.collection('user');

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: StreamBuilder(
            stream: userDatabase.doc(firebaseUser.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                userAccount = snapshot.data;
                return Column(
                  children: [
                    Text(userAccount.data()['username']),
                    Text(userAccount.data()['email']),
                    Text(userAccount.data()['password']),
                  ],
                );
              } else {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
