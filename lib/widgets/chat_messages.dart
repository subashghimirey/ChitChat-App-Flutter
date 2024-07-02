import 'package:chitchat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

//snapshot returns a stream, so we use it there
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            //checking if the list inside the collectoin is empty
            return const Center(
              child: Text("No messges found!!"),
            );
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          final loadedMessages = chatSnapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 40),
            itemCount: loadedMessages.length,
            reverse: true,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();

              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;

              final nextUserIsSame = currentMessageUserId == nextMessageUserId;
              final isMe = currentMessageUserId == currentUser!.uid;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['text'], isMe: isMe);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['text'],
                    isMe: isMe);
              }
            },
          );
        });
  }
}
