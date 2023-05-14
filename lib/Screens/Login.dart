// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Screens/HomePage.dart';
import 'package:socail/Screens/SignUp.dart';
import 'package:socail/Widgets/CustomButton.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/const.dart';
import 'package:socail/Models/User.dart';

import '../Widgets/CustomSnackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

User? user = FirebaseAuth.instance.currentUser;

class _LoginState extends State<Login> {
  initFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => HomePage())));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              content: 'Login',
              size: 20,
              weight: FontWeight.bold,
              color: text,
            ),
            SizedBox(height: 20),
            CustomTExtField(controller: emailController, hint: 'Email'),
            SizedBox(height: 20),
            CustomTExtField(
              controller: passwordController,
              hint: 'Password',
              isPassword: true,
            ),
            SizedBox(height: 20),
            CustomElevatedButtom(
                content: 'Login',
                weight: FontWeight.bold,
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    showSnack(
                        content: 'Please fill all fields', context: context);
                  } else {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => HomePage())));
                    } catch (e) {
                      print(e);
                      showSnack(content: e.toString(), context: context);
                    }
                  }
                }),
            CustomElevatedButtom(
                content: 'Sign up',
                weight: FontWeight.bold,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                }),
          ],
        ),
      )),
    );
  }
}
