import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportBug extends StatefulWidget {
  // Assings the routename for the page
  static const routeName = '/report-bug';

  @override
  _ReportBugState createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  void _trySubmit() async {
    // Checks if all of the validating conditions are met
    final isValid = _formKey.currentState.validate();
    // Removes the on-screen keyboard
    FocusScope.of(context).unfocus();
    // If the input is valid, the following code is executed
    if (isValid) {
      // Current input is saved into variables
      _formKey.currentState.save();
      try {
        // Report is sent to Firestore through an API
        await Firestore.instance.collection('bugs').document().setData({
          'bug': bug,
          'contactInformation': contactInformation,
        }).then((value) {
          // After successful completion, an alert dialog is shown
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Informs the user that the bug has been submitted
                title: Text('Your report has been submitted'),
                content: Text(
                  'We are sorry for the inconvenience. This bug will be fixed quickly.',
                ),
                actions: [
                  // User has option to close alert by clicking the "okay" button
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _formKey.currentState.reset();
                    },
                  )
                ],
              );
            },
          );
        });
      } on PlatformException catch (e) {
        // User will be notified of an error while submitting through an alert dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('There was an error submitting the information'),
              content: Text(e.message),
              actions: [
                // User has option to close alert by clicking the "okay" button
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  String bug;
  String contactInformation;
  // Creates a formkey to identify the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Returns a page to show the report bug screen
    return Scaffold(
      // Returns an App Bar with a title
      appBar: AppBar(
        title: Text('Report a Bug or Suggest a Change'),
      ),
      // Returns a Container with a margin of 25 pixels that has a form to input the bug
      body: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          // Returns a Column of widgets
          child: Column(
            children: [
              // Returns a Text Form Field to input bug or suggestion
              TextFormField(
                // Displays text to enter the bug or suggestion
                decoration: InputDecoration(
                  labelText: 'Enter the Bug or Suggestion',
                ),
                // Validates to make sure that the description of the bug is not empty
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Your description can\'t be empty';
                  }
                  return null;
                },
                // Saves the value in the text field to the string variable "bug"
                onSaved: (String value) {
                  bug = value;
                },
              ),
              // Returns a Text Form Field to input contact information
              TextFormField(
                // Displays text to enter the contact information
                decoration: InputDecoration(
                  labelText: 'Enter Your Contact Information',
                ),
                // Validates to make sure that the contact information isn't empty
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Your contact Information can\'t be empty';
                  }
                  return null;
                },
                // Saves the value in the text field to the string variable "contactInformation"
                onSaved: (String value) {
                  contactInformation = value;
                },
              ),
              SizedBox(height: 20),
              // Returns a button to submit the report and calls the function "_trySubmit" when pressed
              RaisedButton(
                child: Text('Submit Report'),
                onPressed: _trySubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
