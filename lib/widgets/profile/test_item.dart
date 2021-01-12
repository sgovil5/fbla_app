import 'package:flutter/material.dart';

class TestItem extends StatelessWidget {
  final String test;
  final String score;
  TestItem(this.test, this.score);

  @override
  Widget build(BuildContext context) {
    // Creates a row to show multiple widgets
    return Row(
      // Centers the row in the center
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creates a container with a margin to display the specific test
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            test,
            style: TextStyle(fontSize: 10),
          ),
        ),
        // Creates a container with a margin to display the specific score on the test
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
