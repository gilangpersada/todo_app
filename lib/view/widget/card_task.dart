import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/widget/modal.dart';

class CardTask extends StatefulWidget {
  final task;

  const CardTask({Key key, this.task}) : super(key: key);

  @override
  _CardTaskState createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
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
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          widget.task.data()['task_desc'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Modal.bottomSheetTask(
                firebaseUser, context, null, null, widget.task);
          },
          child: Icon(Icons.edit),
        ),
        trailing: GestureDetector(
          onTap: () async {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(firebaseUser.uid)
                .collection('task')
                .doc(widget.task.id)
                .delete();
          },
          child: Icon(
            Icons.delete,
          ),
        ),
        horizontalTitleGap: 4,
      ),
    );
  }
}
