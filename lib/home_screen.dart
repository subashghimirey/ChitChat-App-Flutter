import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;

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
              onPressed: auth.signOut, icon: const Icon(Icons.exit_to_app))
        ], // Customize AppBar color if needed
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Heaven",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
