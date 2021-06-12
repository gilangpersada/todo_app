import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/helper/database_service.dart';
import 'package:todo_app/view/widget/home_bar.dart';
import 'package:todo_app/view/widget/task_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = false;
  String username;
  String email;
  String password;
  String dateToday;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    if (firebaseUser == null) {
      isLoading = true;
    } else {
      DocumentReference<Map<String, dynamic>> userInfo =
          DatabaseService.getUserInfo(firebaseUser.uid);
      userInfo.get().then((value) {
        username = value.data()['username'];
        email = value.data()['email'];
        password = value.data()['password'];
        setState(() {
          isLoading = false;
        });
      });
    }
    return isLoading
        ? Scaffold(
            body: Container(
              color: const Color(0xffF5F5F5),
              child: Center(
                  // child: CircularProgressIndicator(
                  //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  // ),
                  ),
            ),
          )
        : DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0.0,
                backgroundColor: const Color(0xffF5F5F5),
                elevation: 0,
              ),
              body: Stack(
                children: [
                  TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      HomeBar(),
                      TaskBar(),
                      Container(),
                      HomeBar(),
                      HomeBar(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 24),
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        elevation: 12,
                        shadowColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            border: Border.all(
                              color: Colors.black26,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TabBar(
                            labelColor: Colors.grey[900],
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.grey[500],
                            tabs: [
                              Tab(
                                icon: Icon(Icons.home),
                              ),
                              Tab(
                                icon: Icon(Icons.library_books),
                              ),
                              SizedBox(),
                              Tab(
                                icon: Icon(Icons.supervised_user_circle),
                              ),
                              Tab(
                                icon: Icon(Icons.settings),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 48,
                      margin: EdgeInsets.only(bottom: 40),
                      child: FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Colors.grey[800],
                        onPressed: () {},
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
