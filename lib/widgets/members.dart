import 'package:chitchat/inbox.dart';
import 'package:chitchat/others/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Members extends StatelessWidget {
  const Members({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // print(snapshot.error.toString());
          return const Center(child: Text('Some internal error occured'));
        }

        if (snapshot.hasData) {
          var users = snapshot.data!.docs;
          String currentUserId = FirebaseAuth.instance.currentUser!.uid;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var perData = users[index].data() as Map<String, dynamic>;
              String receiverId = perData['id'];

              String chatId = getChatId(currentUserId, receiverId);

              if (receiverId == currentUserId) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Inbox(
                      username: perData['username'],
                      image: perData['image'],
                      chatId: chatId,
                      currentUserId: currentUserId,
                      receiverId: receiverId,
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(perData['image']),
                      radius: 25,
                    ),
                    title: Text(
                      perData['username'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(perData['email']),
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  String getChatId(String user1Id, String user2Id) {
    return user1Id.compareTo(user2Id) < 0
        ? '$user1Id\_$user2Id'
        : '$user2Id\_$user1Id';
  }
}
