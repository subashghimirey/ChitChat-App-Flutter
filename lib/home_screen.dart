import 'package:chitchat/widgets/chat_messages.dart';
import 'package:chitchat/widgets/new_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // User? user = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "ChitChat",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
          ),
          backgroundColor: const Color.fromARGB(255, 48, 222, 112),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  print("signed Out");
                },
                icon: const Icon(Icons.exit_to_app))
          ], // Customize AppBar color if needed
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        ));
  }
}
