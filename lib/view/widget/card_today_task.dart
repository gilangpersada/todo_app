import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardTodayTask extends StatefulWidget {
  final task;

  const CardTodayTask({Key key, this.task}) : super(key: key);

  @override
  _CardTodayTaskState createState() => _CardTodayTaskState();
}

class _CardTodayTaskState extends State<CardTodayTask> {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          widget.task.data()['task'],
          style: TextStyle(
            fontSize: 16,
            decoration: widget.task.data()['isDone']
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          widget.task.data()['task_desc'],
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            decoration: widget.task.data()['isDone']
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        leading: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[900], width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: widget.task.data()['isDone']
              ? Icon(
                  Icons.check,
                  size: 16,
                )
              : SizedBox(),
        ),
        horizontalTitleGap: 4,
        onTap: () async {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(firebaseUser.uid)
              .collection('task')
              .doc(widget.task.id)
              .update({'isDone': !widget.task.data()['isDone']});
          setState(() {});
        },
      ),
    );
  }
}
