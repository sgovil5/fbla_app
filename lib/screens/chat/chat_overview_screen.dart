import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/widgets/chat/chat_profile_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(futureSnapshot.data.uid)
                  .collection('chat')
                  .snapshots(),
              builder: (context, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final userDocs = chatSnapshot.data.documents;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userDocs.length,
                  itemBuilder: (context, index) {
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
