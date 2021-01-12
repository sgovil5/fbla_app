import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/chat/chat_detail_screen.dart';
import 'package:flutter/material.dart';

class ChatProfileItem extends StatelessWidget {
  // Function to navigate to chat with user and the selected receiving user
  void selectChat(BuildContext context, String recieverUid) {
    Navigator.of(context)
        .pushNamed(
      ChatDetail.routeName,
      arguments: recieverUid,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  final String recieverId;
  ChatProfileItem(this.recieverId);
  @override
  Widget build(BuildContext context) {
    // Creates a stream to gather information about the user the message is being sent to
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(recieverId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final user = snapshot.data;
        // Creates a clickable preview
        return InkWell(
          onTap: () {
            // navigates to the actual chat when the Card is clicked
            selectChat(context, recieverId);
          },
          child: Card(
            elevation: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    // Displays the profile picture of the user
                    Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user['image_url']),
                      ),
                    ),
                    // Displays the username of the recieving user with specific alignments and a fontsize of 30
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Text(
                                user['username'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Creates an empty box
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                // Creates a divider between the current user being displayed and the next user
                Divider(
                  thickness: 2,
                  color: Colors.black,
                  height: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
