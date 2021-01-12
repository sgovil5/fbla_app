import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final String achievement;
  final String year;
  AchievementItem(this.achievement, this.year);
  // Constant variables created, Constructor.
  // Template for all achievements.

  @override
  Widget build(BuildContext context) {
    // Creates a row for to display multiple widgets
    return Row(
      // Makes the alignment centered
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creates a container with a margin to display the specific acheivement
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            achievement,
            style: TextStyle(fontSize: 10),
          ),
        ),
        // Creates a container with a margin to display the specific year of the acheivement
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
