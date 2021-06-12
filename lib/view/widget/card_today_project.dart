import 'package:flutter/material.dart';

class CardTodayProject extends StatefulWidget {
  final String project_name;
  final int total_task;

  CardTodayProject({
    this.project_name,
    this.total_task,
  });

  @override
  _CardTodayProjectState createState() => _CardTodayProjectState();
}

class _CardTodayProjectState extends State<CardTodayProject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(right: 16),
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff7E93AC), Color(0xff355070)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project_name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.total_task} total task',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
              ),
            ],
          )
        ],
      ),
    );
  }
}
