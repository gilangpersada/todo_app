import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/widget/card_task.dart';

import 'package:todo_app/view/widget/modal.dart';

class TaskBar extends StatefulWidget {
  @override
  _TaskBarState createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  String selectedDate;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    selectedDate = Jiffy(date).yMMMd;
    User firebaseUser = Provider.of<User>(context);

    return Stack(
      children: [
        Container(
          color: const Color(0xffF5F5F5),
          padding: EdgeInsets.only(top: 8),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: CircleAvatar(
                                radius: 24,
                                child: Icon(Icons.date_range, size: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task',
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
                            Modal.bottomSheetTask(firebaseUser, context,
                                selectedDate, date, null);
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
                              .where('task_date', whereIn: [
                            selectedDate,
                            'everyday'
                          ]).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var task = snapshot.data;

                              return Column(
                                children: task.docs.map<Widget>((task_data) {
                                  return CardTask(
                                    task: task_data,
                                  );
                                }).toList(),
                              );
                            } else {
                              return Text('No data');
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
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.grey[800], // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child,
          );
        },
        context: context,
        initialDate: date,
        firstDate: DateTime(1945, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        date = picked;
      });
  }
}
