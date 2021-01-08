import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/chat/chat_profile_item.dart';

class ChatOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Returns a screen that displays all chats
    return Scaffold(
      //Returns an App Bar with the title "Chat"
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SingleChildScrollView(
        // Returns a Future Builder with a future of the current user
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                // Returns a Circular Progress Indicator if the information is loading
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              // Returns a stream with information about all of the chats of the current user
              stream: Firestore.instance
                  .collection('users')
                  .document(futureSnapshot.data.uid)
                  .collection('chat')
                  .snapshots(),
              builder: (context, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  // Returns a Circular Progress Indicator if the data from the Stream is loading
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final userDocs = chatSnapshot.data.documents;
                // Returns a ListView of a widget
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userDocs.length,
                  itemBuilder: (context, index) {
                    // Returns a Widget detailing the profile of the chats of a user
                    return ChatProfileItem(userDocs[index]['reciever']);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
