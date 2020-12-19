import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PendingItem extends StatelessWidget {
  final String senderUid;

  PendingItem(this.senderUid);

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  void acceptRequest(String myUid, String sendUid) {
    Firestore.instance.collection('users').document(myUid).updateData({
      'friends': FieldValue.arrayUnion([sendUid])
    });
    Firestore.instance.collection('users').document(sendUid).updateData({
      'friends': FieldValue.arrayUnion([myUid])
    });
    Firestore.instance.collection('users').document(myUid).updateData({
      'pending': FieldValue.arrayRemove([sendUid])
    });
  }

  void declineRequest(String myUid, String sendUid) {
    Firestore.instance.collection('users').document(myUid).updateData({
      'pending': FieldValue.arrayRemove([sendUid])
    });
  }

  @override
  Widget build(BuildContext context) {
    String myUid;
    getUser().then((value) => myUid = value);
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(senderUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final userDocs = snapshot.data;
            return Card(
              elevation: 0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userDocs['image_url']),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  userDocs['username'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  userDocs['school'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.green,
                            onPressed: () {
                              acceptRequest(myUid, senderUid);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Request Accepted'),
                                    content: Text(
                                      'You are now friends',
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("Okay"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                              declineRequest(myUid, senderUid);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Request Declined'),
                                    content: Text(
                                      'You have declined the request',
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("Okay"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                    height: 0,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
