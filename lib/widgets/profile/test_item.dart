import 'package:flutter/material.dart';

class TestItem extends StatelessWidget {
  final String test;
  final String score;
  TestItem(this.test, this.score);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            test,
            style: TextStyle(fontSize: 10),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            score,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
