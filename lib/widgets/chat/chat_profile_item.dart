import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/screens/chat/chat_detail_screen.dart';
import 'package:flutter/material.dart';

class ChatProfileItem extends StatelessWidget {
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
        return InkWell(
          onTap: () {
            selectChat(context, recieverId);
          },
          child: Card(
            elevation: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user['image_url']),
                      ),
                    ),
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
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
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
