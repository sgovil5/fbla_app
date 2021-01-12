import '../other/terms_service.dart';
import '../other/report_bug_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherOverViewScreen extends StatelessWidget {
  // Function to select the page to report a bug
  void selectReportBug(BuildContext context) {
    // Navigates to Report Bug page based on routeName
    Navigator.of(context)
        .pushNamed(
      ReportBug.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  // Function to logout by calling the Firebase Authentication API
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  //Function to navigate to the page to select the terms and conditions page
  void selectTerms(BuildContext context) {
    //Navigates to Terms and Conditions page based on routeName
    Navigator.of(context)
        .pushNamed(
      TermsService.routeName,
    )
        .then((result) {
      if (result == null) {}
    });
  }

  // Function to build a section on the Other Page to perform a function
  Widget buildSection(BuildContext context, String text, Function action) {
    // Makes a Column of Widgets
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.black,
          height: 0,
        ),
        // Returns a clickable container
        InkWell(
          // on Clicked it performs the function that is passed to it
          onTap: () => action(context),
          // Returns a centered container with a padding of 20 pixels that displays the text passed into a function
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
    // Returns the screen for the "Other Overview Screen"
    return Scaffold(
      // Returns a column of widgets
      body: Column(
        children: [
          SizedBox(height: 140),
          // Returns a section to report a bug or suggest a change
          // Function to select the report bug page is passed in as a parameter
          buildSection(
              context, 'Report a Bug or Suggest a Change', selectReportBug),
          // Returns a section to logout
          // Function to logout is passed in as a parameter
          buildSection(context, 'Logout', logout),
          //Returns a section to select the terms and conditions
          //Function to select the terms and coditions page is passed in as a paramter
          buildSection(context, 'Terms and Service', selectTerms),
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
