import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/friends/pending_item.dart';
import '../../widgets/profile/profile_preview.dart';
import '../profile/user_overview_screen.dart';
import '../../assets/fonts/my_flutter_app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsOverview extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    // Returns a page to show all the friends of a user
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Friends'),
        actions: [
          // Creates an icon button in the app bar to navigate to the user's profile
          IconButton(
            icon: Icon(MyFlutterApp.graduation_cap),
            onPressed: () {
              selectUserOverview(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        // Returns a future with a future of the current user's information
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                // Returns a Circular Progress Indicator if data is still loading
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              // Creates a stream of data from Firebase about the current user
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
                      // Creates a title to show all pending requests
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
                      // Shows all the pending friend requests for a user
                      // Creates a list view to show all requests from a user's data with a Pending Item widget
                      ListView.builder(
                        itemCount: userDocs['pending'].length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // Passes in the userid of every user who is pending
                          return PendingItem(userDocs['pending'][index]);
                        },
                      ),
                    if (userDocs['friends'].length != 0)
                      // Creates a title to show all friends
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
                      // Shows all the friends for a user
                      // Creates a list view to show all friends from a user's data with a Profile Preview widget
                      ListView.builder(
                        itemCount: userDocs['friends'].length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProfilePreview(
                            // Passes in the user id of every friend
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
