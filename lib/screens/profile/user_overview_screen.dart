import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/widgets/profile/achievement_item.dart';
import 'package:fbla_app/widgets/profile/class_item.dart';
import 'package:fbla_app/widgets/profile/experience_item.dart';
import 'package:fbla_app/widgets/profile/interest_item.dart';
import 'package:fbla_app/widgets/profile/test_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: FutureBuilder(
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
                              backgroundImage:
                                  NetworkImage(userDocs['image_url']),
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
                        physics: NeverScrollableScrollPhysics(),
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
                        physics: NeverScrollableScrollPhysics(),
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
                        physics: NeverScrollableScrollPhysics(),
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
                        physics: NeverScrollableScrollPhysics(),
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
              );
            },
          );
        },
      ),
    );
  }
}
