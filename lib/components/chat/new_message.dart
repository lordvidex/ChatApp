import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  String username;
  FirebaseUser user;
  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void _sendMessage() async {
    if (user == null) user = await FirebaseAuth.instance.currentUser();
    if (username == null)
      username = (await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get())['username'];
    print('$username');
    //.data['username'];
    Firestore.instance.collection('chats').add({
      'text': _controller.text,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': username,
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4, bottom: 2),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _controller.text == '' ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
