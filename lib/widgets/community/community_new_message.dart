import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityNewMessage extends StatefulWidget {
  @override
  _CommunityNewMessageState createState() => _CommunityNewMessageState();
}

class _CommunityNewMessageState extends State<CommunityNewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  // Function to send a message and record it on the Firebase database
  void _sendMessage() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    // Get information about the current user's user Id
    Firestore.instance
        .collection('community')
        .document('community1')
        .updateData({
      'text': FieldValue.arrayUnion([
        {
          'message': _enteredMessage,
          'author': user.uid,
        }
      ])
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the user id of the user who is recieving the caht
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          // Creates a text field for users to input their message and save
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          // Creates an icon button for users to send their message once clicked
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_enteredMessage.trim().isNotEmpty) {
                // If the entereed message is not empty the send message function is called
                _sendMessage();
              }
            },
          ),
        ],
      ),
    );
  }
}
