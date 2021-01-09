import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile/user_overview_screen.dart';
import '../../assets/fonts/my_flutter_app_icons.dart';
import '../../widgets/chat/chat_bubble.dart';
import '../../widgets/chat/new_message.dart';

class ChatDetail extends StatelessWidget {
  // Assigns the routename for the Chat Detail screen
  static const routeName = '/chat-detail';

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
    //Gets the user whom the chat is being sent to
    final String recieveUid = ModalRoute.of(context).settings.arguments;
    // Creates a Future Builder with a source of who the current user is
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          // Returns a Circular Progress Indicator if the application is loading
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          //Returns a Stream Builder with data from a Firebase document where the current user's chat collection contains the document of the receiving user
          stream: Firestore.instance
              .collection('users')
              .document(futureSnapshot.data.uid)
              .collection('chat')
              .where('reciever', isEqualTo: recieveUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Returns a Circular Progress Indicator if the application is loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshot.data.documents;
            // Returns the Screen to display the chat messages
            return Scaffold(
              // Returns an App Bar with the title "Chat"
              appBar: AppBar(
                title: Text('Chat'),
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
              // Returns a Column of Widgets to display the chat
              body: Column(
                children: [
                  Expanded(
                    //Creates a builder to show every chat message
                    child: ListView.builder(
                      shrinkWrap: true,
                      //Displays the number of messages in the database
                      itemCount: chatDocs[0]['messages'].length,
                      itemBuilder: (context, index) {
                        if (chatDocs[0]['messages'][index]['message'] != null)
                          //returns a Chat Bubble with parameters passed in as the sender and message
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
                  // Returns a widget to send a new message
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
