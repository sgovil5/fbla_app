import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportBug extends StatefulWidget {
  static const routeName = '/report-bug';

  @override
  _ReportBugState createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        await Firestore.instance.collection('bugs').document().setData({
          'bug': bug,
          'contactInformation': contactInformation,
        }).then((value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Your report has been submitted'),
                content: Text(
                  'We are sorry for the inconvenience. This bug will be fixed quickly',
                ),
                actions: [
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
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('There was an error'),
              content: Text(e.message),
              actions: [
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Bug'),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter the Bug',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Your description can\'t be empty';
                  }
                  return null;
                },
                onSaved: (String value) {
                  bug = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Your Contact Information',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Your contact Information can\'t be empty';
                  }
                  return null;
                },
                onSaved: (String value) {
                  contactInformation = value;
                },
              ),
              SizedBox(height: 20),
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
