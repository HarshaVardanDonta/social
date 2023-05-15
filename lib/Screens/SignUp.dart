// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Screens/HomePage.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/const.dart';

import '../Widgets/CustomSnackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  bool showPassword = false;

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
              content: 'Sign up',
              size: 20,
              weight: FontWeight.bold,
              color: text,
            ),
            SizedBox(height: 20),
            CustomTExtField(controller: nameController, hint: 'Name'),
            SizedBox(height: 20),
            CustomTExtField(controller: emailController, hint: 'Email'),
            SizedBox(height: 20),
            CustomTExtField(
              controller: passwordController,
              hint: 'Password',
              isPassword: true,
            ),
            SizedBox(height: 20),
            CustomTExtField(
              controller: passwordController2,
              hint: 'Confirm Password',
              isPassword: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: button,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      nameController.text.isEmpty ||
                      passwordController2.text.isEmpty ||
                      passwordController.text != passwordController2.text) {
                    showSnack(
                        content: 'Please fill all fields', context: context);
                  } else {
                    try {
                      var user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      User firebaseUSer = FirebaseAuth.instance.currentUser!;
                      await firebaseUSer.updateDisplayName(nameController.text);
                      var userObj = await UserService.registerUser(UserObj(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          firebaseUid: user.user!.uid,
                          avatar:
                              'https://eu.ui-avatars.com/api/?name=${nameController.text}&size=250',
                          fcm: ''));
                      showSnack(content: 'Success', context: context);

                      if (userObj != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HomePage())));
                      }
                    } catch (e) {
                      // print(e);
                      showSnack(content: e.toString(), context: context);
                    }
                  }
                },
                child: CustomText(
                  content: 'Sign up',
                  size: 20,
                  weight: FontWeight.normal,
                )),
          ],
        ),
      )),
    );
  }
}
