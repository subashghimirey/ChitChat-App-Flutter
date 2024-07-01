import 'package:chitchat/home_screen.dart';
import 'package:chitchat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/auth.dart';
import 'package:chitchat/validators/validators.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loginActive = true;
  final auth = Auth();
  final validator = Validators();
  String errorMessage = '';
  bool _agreeTerms = false;
  bool _isAuthenticating = false;

  File? _selectedImage;

  void onPickImage(pickedImage) {
    _selectedImage = pickedImage;
  }

  void change() {
    setState(() {
      _loginActive = !_loginActive;
      errorMessage = '';
      _formKey.currentState!.reset();
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      _agreeTerms = false;
    });
  }

  void onSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeTerms || _selectedImage == null) {
        if (_selectedImage == null) {
          setState(() {
            errorMessage = "Please click image for profile";
          });
        } else {
          setState(() {
            errorMessage = "Please agree to privacy policies and terms";
          });
        }
      } else {
        try {
          if (mounted) {
            setState(() {
              _isAuthenticating = true;
            });
          }

          var user = await auth.registerUsingEmailAndPassword(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text);

          if (user != null) {
            setState(() {
              _loginActive = !_loginActive;
              errorMessage = '';
            });

            //for storing images in Firebase
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_images')
                .child('${user.uid}.jpg');

            await storageRef.putFile(_selectedImage!);

            final imageURL = await storageRef.getDownloadURL();

            //store all the data of user at a single place using firestore database
            FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'username': nameController.text,
              'email': user.email,
              'image': imageURL
            });

            if (mounted) {
              setState(() {
                _isAuthenticating = false;
              });
            }
          }
        } catch (e) {
          setState(() {
            errorMessage = "Email Already Used!!";
            // _isAuthenticating = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25)
                .copyWith(top: 0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                // padding: EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                    const Text(
                      "ChitChat",
                      style: TextStyle(
                          color: Color.fromARGB(255, 33, 231, 46),
                          fontWeight: FontWeight.w900,
                          fontSize: 75),
                    ),

                    _loginActive
                        ? const SizedBox(
                            height: 0,
                          )
                        : UserImagePicker(
                            onPickImage: onPickImage,
                          ),

                    _loginActive
                        ? const SizedBox(
                            height: 2,
                          )
                        : TextFormField(
                            validator: (value) =>
                                validator.validateName(name: value!),
                            controller: nameController,
                            decoration: const InputDecoration(
                                hintText: "Your Name",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: const Text(
                    //     "Email",
                    //   ),
                    // ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) =>
                          validator.validateEmail(email: value!),
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: "yourgmail@gmail.com",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) =>
                          validator.validatePassword(password: value!),
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          errorMessage,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    _loginActive
                        ? const SizedBox(
                            height: 0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _agreeTerms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _agreeTerms = value!;
                                  });
                                },
                                checkColor: Colors.blue,
                                activeColor: Colors.white,
                              ),
                              const Text(
                                "I agree to all Terms, Privacy Policy",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: _loginActive
                          ? ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    var user =
                                        await auth.loginUsingEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);

                                    if (user != null) {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ));
                                    } else {
                                      setState(() {
                                        errorMessage =
                                            'Invalid login credentials';
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      errorMessage =
                                          "Enter valid credentials to login";
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 48, 153, 239),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 15)),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                            )
                          : !_isAuthenticating
                              ? ElevatedButton(
                                  onPressed: onSignUp,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 48, 153, 239),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 15)),
                                  child: const Text(
                                    "Create Now",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              : null,
                    ),
                    _isAuthenticating
                        ? const CircularProgressIndicator()
                        : const SizedBox(),

                    _loginActive
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Forgot details?",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Reset here",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  ))
                            ],
                          )
                        : const SizedBox(
                            height: 2,
                          ),
                    _loginActive
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                  onPressed: change,
                                  child: const Text(
                                    "Sign Up Now",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  ))
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                  onPressed: change,
                                  child: const Text(
                                    "Login Now",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18),
                                  ))
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
