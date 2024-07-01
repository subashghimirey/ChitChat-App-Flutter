import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
//snapshot returns a stream, so we use it there
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('created_at', descending: false)
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
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 20, top: 5),
                  child: Text(loadedMessages[index].data()['text']));
            },
          );
        });
  }
}
