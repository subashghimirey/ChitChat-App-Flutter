import 'package:chitchat/custom_form.dart';
import 'package:chitchat/home_screen.dart';
import 'package:chitchat/others/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          
          var user = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (user!=null) {
            return const HomeScreen();
          }
          if (!snapshot.hasData) {
            return const CustomForm();
          }

          if (snapshot.data!.isAnonymous) {
            return const CustomForm();
          }
          print("user not logged in now");
          return const CustomForm();
        },
      ),
    ),
  ));
}
