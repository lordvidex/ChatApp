import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/chat/messages.dart';
import '../components/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Chats'), actions: [
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Container(
                    child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                )),
                value: 'logout',
              ),
            ],
            onSelected: (val) {
              switch (val) {
                case 'logout':
                  FirebaseAuth.instance.signOut();
                  break;
                default:
                  return;
              }
            },
          ),
        ]),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        )));
  }
}
