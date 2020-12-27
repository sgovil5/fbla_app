import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/widgets/chat/chat_bubble.dart';
import 'package:fbla_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatelessWidget {
  static const routeName = '/chat-detail';

  @override
  Widget build(BuildContext context) {
    final String recieveUid = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
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
              .where('reciever', isEqualTo: recieveUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshot.data.documents;
            return Scaffold(
              appBar: AppBar(
                title: Text('Chat'),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chatDocs[0]['messages'].length,
                      itemBuilder: (context, index) {
                        if (chatDocs[0]['messages'][index]['message'] != null)
                          return ChatBubble(
                            chatDocs[0]['messages'][index]['message'],
                            chatDocs[0]['messages'][index]['sender'] ==
                                futureSnapshot.data.uid,
                          );
                        else
                          return Container(
                            height: 0,
                            width: 0,
                          );
                      },
                    ),
                  ),
                  NewMessage(recieveUid),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
