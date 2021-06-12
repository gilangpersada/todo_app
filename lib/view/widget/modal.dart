import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Modal {
  static void bottomSheetTask(firebaseUser, context, selectedDate, date, task) {
    TextEditingController taskController = TextEditingController();
    TextEditingController taskDescController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    bool everyday = false;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (builder) {
          if (task != null) {
            taskController.text = task.data()['task'];
            taskDescController.text = task.data()['task_desc'];
            dateController.text = task.data()['task_date'];
            selectedDate = task.data()['task_date'];
            date = DateTime.now();

            if (task.data()['task_date'] == 'everyday') {
              everyday = true;
              selectedDate = Jiffy(date).yMMMd;
            }
          } else {
            taskController.text = '';
            taskDescController.text = '';
            dateController.text = selectedDate;
          }

          return StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(24),
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (task == null) ? "Add task" : 'Edit task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                final DateTime picked = await showDatePicker(
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Colors.grey[
                                                800], // header background color
                                            onPrimary: Colors
                                                .white, // header text color
                                            onSurface:
                                                Colors.black, // body text color
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: Colors
                                                  .black, // button text color
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
                                    selectedDate = Jiffy(date).yMMMd;
                                    dateController.text = selectedDate;
                                  });
                              },
                              child: !everyday
                                  ? Icon(
                                      Icons.date_range,
                                      color: Colors.grey[800],
                                    )
                                  : SizedBox(),
                            ),
                            hintText: 'Task date',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            everyday = !everyday;
                            if (!everyday) {
                              dateController.text = selectedDate;
                            } else {
                              dateController.text = 'Every day';
                            }
                          });
                        },
                        child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[900], width: 1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: everyday
                                ? Icon(
                                    Icons.check,
                                    size: 12,
                                  )
                                : SizedBox()),
                      ),
                      SizedBox(width: 8),
                      Text('Every day'),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Task name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    minLines: 2,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    controller: taskDescController,
                    decoration: InputDecoration(
                      hintText: 'description',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      if (task == null) {
                        if (everyday) {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(firebaseUser.uid)
                              .collection('task')
                              .add({
                            'task': taskController.text,
                            'task_desc': taskDescController.text,
                            'task_date': 'everyday',
                            'isDone': false
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(firebaseUser.uid)
                              .collection('task')
                              .add({
                            'task': taskController.text,
                            'task_desc': taskDescController.text,
                            'task_date': selectedDate,
                            'task_timestamp': date,
                            'isDone': false
                          });
                        }
                      } else {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(firebaseUser.uid)
                            .collection('task')
                            .doc(task.id)
                            .update({
                          'task': taskController.text,
                          'task_desc': taskDescController.text,
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Text(
                        (task == null) ? 'Add' : 'Edit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
