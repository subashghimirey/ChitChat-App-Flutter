import 'package:chitchat/auth.dart';
import 'package:chitchat/custom_form.dart';
import 'package:chitchat/widgets/members.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = Auth();

  void setUpPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    fcm.requestPermission();
    // final token = await fcm.getToken();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setUpPushNotifications();
  }

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
                await auth.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const CustomForm(),
                ));
                // print("signed Out");
              },
              icon: const Icon(Icons.exit_to_app))
        ], // Customize AppBar color if needed
      ),
      body: const Column(
        children: [
          // Expanded(child: ChatMessages()),
          // NewMessage(),
          Expanded(child: Members())
        ],
      ),
    );
  }
}
