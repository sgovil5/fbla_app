import 'package:flutter/material.dart';

class ExperienceItem extends StatelessWidget {
  final String experience;
  final String year;
  ExperienceItem(this.experience, this.year);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            experience,
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
}
