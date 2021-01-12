import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PendingItem extends StatelessWidget {
  final String senderUid;

  PendingItem(this.senderUid);

  // taps in to the instance of firebase auth with the auth variable
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Gets the current user's information
  Future<String> getUser() async {
    // uses the instance of firebase auth to get the user and their user id
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  // Function to accept a friend request
  void acceptRequest(String myUid, String sendUid) {
    // Adds a the recieving user to the sending user's friends
    Firestore.instance.collection('users').document(myUid).updateData({
      'friends': FieldValue.arrayUnion([sendUid])
    });
    // Adds a the sending user to the recieving user's friends
    Firestore.instance.collection('users').document(sendUid).updateData({
      'friends': FieldValue.arrayUnion([myUid])
    });
    // Removes the sending user from the list of pending requests
    Firestore.instance.collection('users').document(myUid).updateData({
      'pending': FieldValue.arrayRemove([sendUid])
    });
  }

  // Function to decline a friend request
  void declineRequest(String myUid, String sendUid) {
    // Removes the sending user from the list of pending users
    Firestore.instance.collection('users').document(myUid).updateData({
      'pending': FieldValue.arrayRemove([sendUid])
    });
  }

  @override
  Widget build(BuildContext context) {
    // Assigns the value of the current user id to the "myUid" variable
    String myUid;
    getUser().then((value) => myUid = value);
    // Creates a future builder with a future based on the current user's information
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Creates a stream builder to gather information about the sending user
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
            // Returns a card with a column to display multiple widgets
            return Card(
              elevation: 0,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Creates a container to show the user's profile image
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userDocs['image_url']),
                        ),
                      ),

                      Expanded(
                        // Creates a container with a column to show multiple texts
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Creates a container to show the username of the user in a centered manner
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
                              // Creates a container to show the school of the username in a centered manner
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
                      // Creates a column of icons
                      Column(
                        children: [
                          // Creates an icon with a green check mark
                          IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.green,
                            onPressed: () {
                              // Calls the accept friend request function when clicked
                              acceptRequest(myUid, senderUid);
                              // Shows an alert dialog informing the user of success
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Request Accepted'),
                                    content: Text(
                                      'You are now friends',
                                    ),
                                    actions: [
                                      // The user can click okay to dismiss the alert dialog
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
                          // Creates an icon that is red with a cancel icon to decline a request
                          IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                              // Calls the function to decline request
                              declineRequest(myUid, senderUid);
                              // Shows alert dialog to notify the user that the request has been declined
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Request Declined'),
                                    content: Text(
                                      'You have declined the request',
                                    ),
                                    actions: [
                                      // USer can dismiss alert by clicking okay
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
                  // Creates a divider
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
