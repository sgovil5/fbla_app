import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/screens/profile/profile_edit.dart';
import 'package:fbla_app/widgets/profile/achievement_item.dart';
import 'package:fbla_app/widgets/profile/class_item.dart';
import 'package:fbla_app/widgets/profile/experience_item.dart';
import 'package:fbla_app/widgets/profile/interest_item.dart';
import 'package:fbla_app/widgets/profile/test_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserOverview extends StatelessWidget {
  static const routeName = '/user-profile';

  void selectEditor(BuildContext context, String uid) {
    Navigator.of(context)
        .pushNamed(
      ProfileEdit.routeName,
      arguments: uid,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  @override
  Widget build(BuildContext context) { // Displays the My Profile Page.
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
              .document(futureSnapshot.data.uid)
              .snapshots(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final userDocs = userSnapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('My Profile'), // Header
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      selectEditor(context, futureSnapshot.data.uid);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
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
                              backgroundImage: userDocs['image_url'] == null
                                  ? NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/300px-No_image_available.svg.png')
                                  : NetworkImage(userDocs['image_url']), // User Profile Picture or standard picture.
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
                                      userDocs['username'] == ''
                                          ? 'No username'
                                          : userDocs['username'], // Displays username.
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      userDocs['school'] == ''
                                          ? 'No School'
                                          : userDocs['school'], // Displays School.
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
                      child: Text(userDocs['description']), // Displays description.
                    ),
                    if (userDocs['classes'].length != 0)
                      Container(
                        child: Text(
                          'This is a list of classes taken by ${userDocs['username']}', // Displays classes
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: userDocs['classes'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return ClassItem(
                            userDocs['classes'][index]['class'],
                            userDocs['classes'][index]['grade'],
                            userDocs['classes'][index]['year'], // centered and spaced out properly.
                          );
                        },
                      ),
                    ),
                    if (userDocs['test_scores'].length != 0) // Similarily for test scores
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
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return TestItem(
                            userDocs['test_scores'][index]['test'],
                            userDocs['test_scores'][index]['score'],
                          );
                        },
                      ),
                    ),
                    if (userDocs['interests'].length != 0) // Interests
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
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return InterestItem(
                            userDocs['interests'][index],
                          );
                        },
                      ),
                    ),
                    if (userDocs['achievements'].length != 0) // Achievements
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
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return AchievementItem(
                            userDocs['achievements'][index]['achievement'],
                            userDocs['achievements'][index]['year'],
                          );
                        },
                      ),
                    ),
                    if (userDocs['experiences'].length != 0) // Experiences
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
                        physics: NeverScrollableScrollPhysics(),
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
