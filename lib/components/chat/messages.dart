import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import './message_bubble.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('chats')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (ctx2, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = streamSnapshot.data.documents;

                //to move objects to the end of the list.. add a postframecallback
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });

                return ListView.builder(
                    controller: _scrollController,
                    itemCount: docs.length,
                    itemBuilder: (ctx3, index) {
                      return MessageBubble(
                          key: ValueKey(docs[index].documentID),
                          message: docs[index].data['text'],
                          username: docs[index].data['username'],
                          userImage: docs[index].data['userImage'],
                          isMe: docs[index].data['userId'] ==
                              futureSnapshot.data.uid);
                    });
              });
        });
  }
}
