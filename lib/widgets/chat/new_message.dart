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
  void _sendMessage(String recieveId) async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final recieverData = await Firestore.instance
        .collection('users')
        .document(recieveId)
        .collection('chat')
        .where('reciever', isEqualTo: user.uid)
        .getDocuments();
    final senderData = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('chat')
        .where('reciever', isEqualTo: recieveId)
        .getDocuments();
    senderData.documents.forEach((element) {
      print(element.documentID);
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
    recieverData.documents.forEach((element) {
      print(element.documentID);
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
    String recieverId = widget.reciever;
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
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
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_enteredMessage.trim().isNotEmpty) {
                _sendMessage(recieverId);
              }
            },
          ),
        ],
      ),
    );
  }
}
