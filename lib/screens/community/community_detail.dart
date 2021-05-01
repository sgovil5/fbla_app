import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/assets/fonts/my_flutter_app_icons.dart';
import 'package:fbla_app/screens/profile/user_overview_screen.dart';
import 'package:fbla_app/widgets/chat/chat_bubble.dart';
import 'package:fbla_app/widgets/community/community_new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityDetail extends StatelessWidget {
  static const routeName = '/community-detail';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Communities"),
        actions: [
          // Creates an icon button in the app bar to navigate to the user's profile
          IconButton(
            icon: Image.asset('lib/assets/icons/Logo_Circular.png'),
            onPressed: () {
              selectUserOverview(context);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return StreamBuilder(
            stream: Firestore.instance
                .collection('community')
                .document('community1')
                .snapshots(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              final chatDocs = docSnapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatDocs['text'].length,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                            chatDocs['text'][index]['message'],
                            chatDocs['text'][index]['author'] ==
                                snapshot.data.uid);
                      },
                    ),
                  ),
                  CommunityNewMessage(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
