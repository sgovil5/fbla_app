import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/widgets/friends/pending_item.dart';
import 'package:fbla_app/widgets/profile/profile_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Friends'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                return Column(
                  children: [
                    if (userDocs['pending'].length != 0)
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        margin: EdgeInsets.all(30),
                        child: Text(
                          'Pending Requests',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (userDocs['pending'].length != 0)
                      ListView.builder(
                        itemCount: userDocs['pending'].length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return PendingItem(userDocs['pending'][index]);
                        },
                      ),
                    if (userDocs['friends'].length != 0)
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        margin: EdgeInsets.all(30),
                        child: Text(
                          'Friends',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (userDocs['friends'].length != 0)
                      ListView.builder(
                        itemCount: userDocs['friends'].length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProfilePreview(
                            userDocs['friends'][index],
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
