import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  void onSend() async {
    var userMessage = _messageController.text;

    if (userMessage.trim().isEmpty) {
      return;
    }
    _messageController.clear();
    //to close the keyboard
    // FocusScope.of(context).unfocus();

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection("chat").add({
      'text': userMessage,
      'created_at': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['image'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 14,
        right: 1,
        bottom: 25,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                  hintText: "Type message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
          IconButton(onPressed: onSend, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
