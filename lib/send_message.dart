import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({
    super.key,
    required this.chatId,
    required this.receiverId,
  });

  final String chatId;
  final String receiverId;

  @override
  State<SendMessage> createState() {
    return _SendMessageState();
  }
}

class _SendMessageState extends State<SendMessage> {
  final _messageController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  File? pickedImage;

  void pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    setState(() {
      pickedImage = File(image.path);
    });

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_uploaded_images')
        .child(imageName);

    await storageRef.putFile(pickedImage!);
    String imageUrl = await storageRef.getDownloadURL();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
      'senderId': user.uid,
      'receiverId': widget.receiverId,
    });
  }

  void onSend() async {
    var userMessage = _messageController.text;

    if (userMessage.trim().isEmpty) {
      return;
    }
    _messageController.clear();
    // Close the keyboard
    FocusScope.of(context).unfocus();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': userMessage,
      'timestamp': Timestamp.now(),
      'senderId': user.uid,
      'receiverId': widget.receiverId,
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
          IconButton(
              onPressed: pickImage,
              icon: const Icon(
                Icons.image,
                size: 30,
              )),
          IconButton(onPressed: onSend, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
