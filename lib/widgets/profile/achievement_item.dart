import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final String achievement;
  final String year;
  AchievementItem(this.achievement, this.year);
  // Constant variables created, Constructor.
  // Parent class for all achievements

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            achievement,
            style: TextStyle(fontSize: 10),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            year,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
  // Centering and font size are set. 
}
