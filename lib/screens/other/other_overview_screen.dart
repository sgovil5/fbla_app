import 'package:fbla_app/screens/other/report_bug_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherOverViewScreen extends StatelessWidget {
  void selectReportBug(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      ReportBug.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  Widget buildSection(BuildContext context, String text, Function action) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.black,
          height: 0,
        ),
        InkWell(
          onTap: () => action(context),
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 140),
          buildSection(context, 'Report a Bug', selectReportBug),
          buildSection(context, 'Logout', logout),
          Divider(
            thickness: 2,
            color: Colors.black,
            height: 0,
          ),
        ],
      ),
    );
  }
}
