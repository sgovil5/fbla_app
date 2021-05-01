import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/chat/chat_detail_screen.dart';
import '../../widgets/profile/achievement_item.dart';
import '../../widgets/profile/class_item.dart';
import '../../widgets/profile/experience_item.dart';
import '../../widgets/profile/interest_item.dart';
import '../../widgets/profile/test_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './user_overview_screen.dart';
import '../../assets/fonts/my_flutter_app_icons.dart';

class ProfileDetail extends StatelessWidget {
  static const routeName = '/profile-detail';

  // Function to navigate to the user's profile page
  void selectUserOverview(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      UserOverview.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  // Function to navigate to the selected chat.
  void selectChat(BuildContext context, String recieverUid) {
    Navigator.of(context)
        .pushNamed(
      ChatDetail.routeName,
      arguments: recieverUid,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  // Function to send a friend request.
  void sendRequest(DocumentSnapshot recieveUser, String sendUser) {
    Firestore.instance
        .collection('users')
        .document(recieveUser.documentID)
        .updateData({
      'pending': FieldValue.arrayUnion([sendUser])
    });
  }

  // Function to start a chat with a new user.
  Future<void> addChat(DocumentSnapshot recieveUser, String sendUser) async {
    final recieverData = await Firestore.instance
        .collection('users')
        .document(recieveUser.documentID)
        .collection('chat')
        .where('reciever',
            isEqualTo:
                sendUser) // Finding the user current user wishes to chat with.
        .getDocuments()
        .then((value) {
      final recieverDocs = value.documents;
      print(recieverDocs);
      if (recieverDocs.length == 0) {
        // Creation of a new conversation in Firebase if there is no pre-existing chat.
        // Creates document in chat collection of sending user to start initiate a conversation
        Firestore.instance
            .collection('users')
            .document(sendUser)
            .collection('chat')
            .add({
          'messages': [
            {
              'message': null,
              'sender': null,
            }
          ],
          'reciever': recieveUser.documentID,
        });
        // Creates document in chat collection of recieving user to start initiate a conversation
        Firestore.instance
            .collection('users')
            .document(recieveUser.documentID)
            .collection('chat')
            .add({
          'messages': [
            {
              'message': null,
              'sender': null,
            }
          ],
          'reciever': sendUser,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gets information about the user through the page that it as navigated from
    final DocumentSnapshot user = ModalRoute.of(context).settings.arguments;
    // Creates a future builder to get data about the current user
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Creates a stream to get information about the user and their profile
        return StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(user.documentID)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            bool isMe;
            String myUid = futureSnapshot.data.uid;
            final userDocs = userSnapshot.data;
            // Checks if the user is on their own page
            if (myUid == user.documentID)
              isMe = true;
            else
              isMe = false;
            return Scaffold(
              // Displays profile page.
              appBar: AppBar(
                title: Text(user['username']), // Header
                actions: [
                  // Creates an icon to add a friend in the App Bar
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      //If the user tries to friend themselves
                      if (isMe) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            // Alert shows up prompting user that they can't friend themselves
                            return AlertDialog(
                              title: Text('This is your profile'),
                              content:
                                  Text('You cannot add yourself as a friend'),
                              actions: [
                                FlatButton(
                                  child: Text("Okay"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else if (!(user['friends'].contains(myUid))) {
                        // If user is not already friends with selected user.
                        sendRequest(user, myUid); // Sends request
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  'Request Sent'), // Alerts user that request has been sent.
                              content:
                                  Text('Your friend request has been sent'),
                              actions: [
                                FlatButton(
                                  child: Text("Okay"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Press button to dismiss message.
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        // User is friends with selected user.
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  'Can\'t send request'), // Alerts user that a request cannot be sent.
                              content: Text(
                                  'You are already friends with this user'),
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
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      if (isMe) {
                        // If user tries to chat with themselves.
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('This is your profile'),
                              content: Text(
                                  'You cannot chat with yourself'), // App will not let the user chat with themselves.
                              actions: [
                                FlatButton(
                                  child: Text("Okay"),
                                  onPressed: () {
                                    // Dismiss message.
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Creates a new chat and navigates to the new chat
                        addChat(user, myUid).then((value) {
                          selectChat(context, user.documentID);
                        });
                      }
                    },
                  ),
                  // Allows for the user to click the icon and brings them back to their own profile page
                  IconButton(
                    icon: Image.asset('lib/assets/icons/Logo_Circular.png'),
                    onPressed: () {
                      selectUserOverview(context);
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                // Allows scrollong.
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      height: 125,
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage:
                                  NetworkImage(userDocs['image_url']),
                            ),
                          ),
                          Expanded(
                            // Displaying the in-depth profile page, also found on user's profile page.
                            // Highlight components with comments.
                            child: Container(
                              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      userDocs['username'], // Displays username
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.only(top: 15),
                                    height: 50,
                                    child: Text(
                                      userDocs['school'], // School
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(userDocs['description']), // Description
                    ),
                    if (userDocs['classes'].length !=
                        0) // Classes, spaced out and centered.
                      Container(
                        child: Text(
                          'This is a list of classes taken by ${userDocs['username']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    Container(
                      width: double
                          .infinity, // Allows for an indeterminate number of classes. Similar usage for other categories.
                      child: ListView.builder(
                        itemCount: userDocs['classes'].length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return ClassItem(
                            userDocs['classes'][index]['class'],
                            userDocs['classes'][index]['grade'],
                            userDocs['classes'][index]['year'],
                          );
                        },
                      ),
                    ),
                    if (userDocs['test_scores'].length !=
                        0) // Test scores, spaced out and centered.
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'This is a list of test scores achieved by ${userDocs['username']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: userDocs['test_scores'].length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return TestItem(
                            userDocs['test_scores'][index]['test'],
                            userDocs['test_scores'][index]['score'],
                          );
                        },
                      ),
                    ),
                    if (userDocs['interests'].length !=
                        0) // Interest, centered.
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'This is a list of interests of ${userDocs['username']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: userDocs['interests'].length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return InterestItem(
                            userDocs['interests'][index],
                          );
                        },
                      ),
                    ),
                    if (userDocs['achievements'].length !=
                        0) // Achievements, with parameters spaced out and centered.
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'This is a list of achievements by ${userDocs['username']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: userDocs['achievements'].length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return AchievementItem(
                            userDocs['achievements'][index]['achievement'],
                            userDocs['achievements'][index]['year'],
                          );
                        },
                      ),
                    ),
                    if (userDocs['experiences'].length !=
                        0) // Experiences, with parameters spaced out and centered on screen.
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'This is a list of professional experience of ${userDocs['username']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    // Creates a list of all parameters of a user's experience
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: userDocs['experiences'].length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return ExperienceItem(
                            userDocs['experiences'][index]['experience'],
                            userDocs['experiences'][index]['year'],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
