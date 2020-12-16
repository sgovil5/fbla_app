import 'package:flutter/material.dart';

class InterestItem extends StatelessWidget {
  final String interest;
  InterestItem(this.interest);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            interest,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
