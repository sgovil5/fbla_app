import 'package:flutter/material.dart';

class ClassItem extends StatelessWidget {
  final String cls; //class
  final String grade;
  final String year;
  ClassItem(this.cls, this.grade, this.year);
  @override
  Widget build(BuildContext context) {
    return Row( // Each row consists of three categories, a class, grade, and year.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            cls, // class text
            style: TextStyle(fontSize: 10),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            grade, // grade text
            style: TextStyle(fontSize: 10),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            year, // year text
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
