import 'package:flutter/material.dart';

class ExperienceItem extends StatelessWidget {
  final String experience;
  final String year;
  ExperienceItem(this.experience, this.year);
  // Constant variables and constructor. Each Experience Item contains the experience title and year.

  @override
  Widget build(BuildContext context) {
    // Creates a row to display multiple widgets
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creates a container with a margin to display the specific experience
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            experience, // Experience title text.
            style: TextStyle(fontSize: 10),
          ),
        ),
        // Creates a container with a margin to display the specific year of the experience
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            year, // Year text.
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
