import 'package:flutter/material.dart';

class InterestItem extends StatelessWidget {
  final String interest;
  InterestItem(this.interest);
  // Constant variable interest and constuctor. Each Interest Item consists of a a single string.

  @override
  Widget build(BuildContext context) {
    // Creates a row to show multiple widgets
    return Row(
      // Centers the row vertically
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creates a container with a margin to display the specific interest
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            interest, // interest text.
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
