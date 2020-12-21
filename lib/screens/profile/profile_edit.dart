import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/edit-profile';
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  void deleteItem(DocumentSnapshot userDocs, String category, int index) {
    Firestore.instance
        .collection('users')
        .document(userDocs.documentID)
        .updateData({
      category: FieldValue.arrayRemove([userDocs[category][index]])
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit your profile"),
      ),
      body: StreamBuilder(
        stream:
            Firestore.instance.collection('users').document(userId).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final userDocs = userSnapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Edit your Profile",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Edit your classes",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userDocs['classes'].length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Text(
                            userDocs['classes'][index]['class'],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Text(
                            userDocs['classes'][index]['grade'],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Text(
                            userDocs['classes'][index]['year'],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteItem(userDocs, 'classes', index);
                              print(index);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.add_circle_outline),
                  color: Colors.green,
                  onPressed: () {
                    String cls;
                    String grade;
                    String year;
                    final GlobalKey<FormState> _formKey =
                        GlobalKey<FormState>();
                    void trySubmit() async {
                      final isValid = _formKey.currentState.validate();
                      FocusScope.of(context).unfocus();
                      if (isValid) {
                        _formKey.currentState.save();
                        try {
                          await Firestore.instance
                              .collection('users')
                              .document(userId)
                              .updateData({
                            'classes': FieldValue.arrayUnion([
                              {'class': cls, 'grade': grade, 'year': year}
                            ])
                          }).then(
                            (value) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Your class was submitted'),
                                    content: Text(
                                        'It will now show up on your profile'),
                                    actions: [
                                      FlatButton(
                                        child: Text('Okay'),
                                        onPressed: () {
                                          _formKey.currentState.reset();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
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

                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Enter the class'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Your class cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  cls = value;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText:
                                        'Enter the grade you took the class in'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Your grade cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  grade = value;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText:
                                        'Enter the year you took the class in'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Your year cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  year = value;
                                },
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  trySubmit();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
            //Copy above template and make according edits
          );
        },
      ),
    );
  }
}
