import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/widget/card_today_project.dart';
import 'package:todo_app/view/widget/card_today_task.dart';
import 'package:todo_app/view/widget/modal.dart';

class HomeBar extends StatefulWidget {
  @override
  _HomeBarState createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  String dateToday;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    dateToday = Jiffy(now).yMMMd;
    User firebaseUser = Provider.of<User>(context);

    return Stack(
      children: [
        Container(
          color: const Color(0xffF5F5F5),
          padding: EdgeInsets.only(top: 48),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today Project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            children: [
                              CardTodayProject(
                                project_name: 'App Design',
                                total_task: 5,
                              ),
                              CardTodayProject(
                                project_name: 'App Design',
                                total_task: 5,
                              ),
                              CardTodayProject(
                                project_name: 'App Design',
                                total_task: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            DefaultTabController.of(context).animateTo(1);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.green),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Add task',
                                    style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .doc(firebaseUser.uid)
                              .collection('task')
                              .where('task_date', isEqualTo: dateToday)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data.docs.isNotEmpty) {
                                var task = snapshot.data;

                                return Column(
                                  children: task.docs.map<Widget>((task_data) {
                                    return CardTodayTask(
                                      task: task_data,
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffF5F5F5),
          padding: EdgeInsets.symmetric(horizontal: 24),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    dateToday,
                    style: TextStyle(color: Colors.grey[900], fontSize: 12),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.notifications,
                      color: Color(0xff252525),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xffF5F5F5),
                    radius: 15,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.grey[900],
                      size: 28,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
