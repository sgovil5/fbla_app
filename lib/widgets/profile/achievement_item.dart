import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final String achievement;
  final String year;
  AchievementItem(this.achievement, this.year);
  // Constant variables created, Constructor.
  // Template for all achievements in profile page

  @override
  Widget build(BuildContext context) {
    //Creates a Row of Containers with Center Alignment
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Creates a Container to display the text of the achievement and sets fontsize along with a margin of 15 pixels.
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            achievement,
            style: TextStyle(fontSize: 10),
          ),
        ),
        //Creates a Container to display the year of the achievement and sets fontsize along with a margin of 15 pixels.
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
}
