import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futuresnapshot) {
        if (futuresnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('CreatedAt', descending: true)
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatdocuments = streamSnapshot.data!.documents;

              return ListView.builder(
                reverse: true,
                itemCount: chatdocuments.length,
                itemBuilder: (ctx, item) => MessageBubble(
                  chatdocuments[item]['text'],
                  chatdocuments[item]['userid'] == futuresnapshot.data!.uid,
                  chatdocuments[item]['username'],
                  chatdocuments[item]['userimage'],
                  key: ValueKey(chatdocuments[item].documentID),
                ),
              );
            });
      },
    );
  }
}
