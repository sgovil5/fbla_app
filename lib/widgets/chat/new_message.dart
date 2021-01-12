import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  final String reciever;
  NewMessage(this.reciever);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  // Function to send a message and record it on the Firebase database
  void _sendMessage(String recieveId) async {
    // Close the keyboard
    FocusScope.of(context).unfocus();
    // Get information about the current user's user Id
    final user = await FirebaseAuth.instance.currentUser();
    // Get information about the recieving user's data
    final recieverData = await Firestore.instance
        .collection('users')
        .document(recieveId)
        .collection('chat')
        .where('reciever', isEqualTo: user.uid)
        .getDocuments();
    // Get information about the current user's data
    final senderData = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('chat')
        .where('reciever', isEqualTo: recieveId)
        .getDocuments();
    // Add the message to the sender's document with the reciever user outlined in the chat collection
    // The chat collection is stored in the document for the current user
    senderData.documents.forEach((element) {
      // Append the data to an array storing every chat between a person
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('chat')
          .document(element.documentID)
          .updateData({
        'messages': FieldValue.arrayUnion([
          {
            'message': _enteredMessage,
            'sender': user.uid,
          }
        ])
      });
    });
    // Add the message to the reciever's document with the serding user outlined in the chat collection
    // The chat collection is stored in the document for the recieving user
    recieverData.documents.forEach((element) {
      // Append the data to an array storing every chat between a person
      Firestore.instance
          .collection('users')
          .document(recieveId)
          .collection('chat')
          .document(element.documentID)
          .updateData({
        'messages': FieldValue.arrayUnion([
          {
            'message': _enteredMessage,
            'sender': user.uid,
          }
        ])
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Gets the user id of the user who is recieving the caht
    String recieverId = widget.reciever;
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
                _sendMessage(recieverId);
              }
            },
          ),
        ],
      ),
    );
  }
}
