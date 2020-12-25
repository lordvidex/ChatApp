import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
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
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx3, index) {
                      return 
                      MessageBubble(
                          ValueKey(docs[index].documentID),
                          docs[index].data['text'],
                          docs[index].data['username'],
                          docs[index].data['userId'] ==
                              futureSnapshot.data.uid);
                    });
              });
        });
  }
}
