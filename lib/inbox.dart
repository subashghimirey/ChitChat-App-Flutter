import 'package:chitchat/others/splash_screen.dart';
import 'package:chitchat/send_message.dart'; // Updated import
import 'package:chitchat/widgets/bubble_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Inbox extends StatelessWidget {
  const Inbox({
    super.key,
    required this.username,
    required this.image,
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
  });

  final String username;
  final String image;
  final String chatId;
  final String currentUserId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(username)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  var messages = snapshot.data!.docs;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        "Send your first message now!! 🤞👈",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var messageData =
                          messages[index].data() as Map<String, dynamic>;
                      bool isMe = messageData['senderId'] == currentUserId;
                      Timestamp timestamp = messageData['timestamp'];
                      DateTime messageTime = timestamp.toDate();
                      bool showTime = false;
                      bool showDate = false;

                      // Check if this is the first message or if the sender is different from the previous message

                      bool showUserImage = false;
                      if (index < messages.length - 1) {
                        var previousMessageData =
                            messages[index + 1].data() as Map<String, dynamic>;

                        var previousTimestamp =
                            previousMessageData['timestamp'] as Timestamp;
                        var previousMessageTime = previousTimestamp.toDate();

                        showUserImage = messageData['senderId'] !=
                            previousMessageData['senderId'];

                        var timeDifference =
                            messageTime.difference(previousMessageTime);
                        if (timeDifference.inMinutes > 10) {
                          showTime = true;
                        }
                        if (timeDifference.inDays > 1) {
                          showDate = true;
                        }
                      }

                      // return MessageBubble(
                      //   message: messageData['text'],
                      //   isMe: isMe,
                      //   showUserImage: showUserImage,
                      //   userImage: messageData['senderId'] == currentUserId
                      //       ? "" // Assuming you have this value
                      //       : image,
                      // );
                      return Column(children: [
                        if (showDate)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 12),
                              child: Text(
                                DateFormat('MMMM dd, yyyy').format(messageTime),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                        if (showTime)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('HH:mm').format(messageTime),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                        BubbleMessage(
                          isMe: isMe,
                          message: messageData['text'],
                          username:
                              isMe ? auth.currentUser!.displayName! : username,
                          showUserImage: showUserImage,
                          profileimage: image,
                          image: messageData['imageUrl'],
                        ),
                      ]);
                    },
                  );
                }
                return const Center(child: Text('No messages yet'));
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SendMessage(chatId: chatId, receiverId: receiverId),
        ],
      ),
    );
  }
}
