import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/widgets/profile/achievement_item.dart';
import 'package:fbla_app/widgets/profile/class_item.dart';
import 'package:fbla_app/widgets/profile/experience_item.dart';
import 'package:fbla_app/widgets/profile/interest_item.dart';
import 'package:fbla_app/widgets/profile/test_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  static const routeName = '/profile-detail';

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  Future<bool> checkFriends(
      DocumentSnapshot recieveUser, String sendUser) async {
    Firestore.instance
        .collection('users')
        .document(recieveUser.documentID)
        .get()
        .then((value) {
      final userDoc = value;
      List<dynamic> friendList = userDoc['friends'].toList();
      if (friendList.contains(sendUser)) {
        return true;
      } else
        return false;
    });
  }

  void sendRequest(DocumentSnapshot recieveUser, String sendUser) {
    Firestore.instance
        .collection('users')
        .document(recieveUser.documentID)
        .updateData({
      'pending': FieldValue.arrayUnion([sendUser])
    });
  }

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot user = ModalRoute.of(context).settings.arguments;
    String myUid;
    bool areFriends;
    getUser().then((value) {
      myUid = value;
      checkFriends(user, myUid).then((value) => areFriends = true);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(user['username']),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              if (myUid == user.documentID) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('This is your profile'),
                      content: Text('You cannot add yourself as a friend'),
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
              } else {
                if (!areFriends) {
                  sendRequest(user, myUid);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Request Sent'),
                        content: Text('Your friend request has been sent'),
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
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Can\'t send request'),
                        content: Text('You are already friends with this user'),
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
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.documentID)
            .snapshots(),
        builder: (ctx, userSnapshot) {
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
                  margin: EdgeInsets.all(20),
                  height: 125,
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(userDocs['image_url']),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  userDocs['username'],
                                  style: TextStyle(
                                    fontSize: 30,
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
                  child: Text(userDocs['description']),
                ),
                if (userDocs['classes'].length != 0)
                  Container(
                    child: Text(
                      'This is a list of classes taken by ${userDocs['username']}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                Container(
                  width: double.infinity,
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
                if (userDocs['test_scores'].length != 0)
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
                if (userDocs['interests'].length != 0)
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
                if (userDocs['achievements'].length != 0)
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
                if (userDocs['experiences'].length != 0)
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      'This is a list of professional experience of ${userDocs['username']}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
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
          );
        },
      ),
    );
  }
}
