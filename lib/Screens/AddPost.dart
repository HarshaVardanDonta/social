// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Models/Post.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Screens/CameraScreen.dart';
import 'package:socail/Widgets/CustomButton.dart';
import 'package:socail/Widgets/CustomSnackbar.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/const.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

CameraController? controller;
late List<CameraDescription> _cameras;
bool init = false;

bool imageCaptured = false;
late XFile image;

class _AddPostState extends State<AddPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    imageCaptured = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: back,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: button,
                            // borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: titleController,
                                style: GoogleFonts.poppins(
                                    color: text, fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  hintStyle:
                                      TextStyle(color: text, fontSize: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: descController,
                                style: GoogleFonts.poppins(
                                    color: text, fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle:
                                      TextStyle(color: text, fontSize: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 400,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: container,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: imageCaptured
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(image.path),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CamerScreen()))
                                              .then((value) {
                                            setState(() {
                                              image = value;
                                              imageCaptured = true;
                                              // loading = true;
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 400,
                                          width: double.infinity,
                                          child: Center(
                                              child: Icon(
                                            Icons.add_a_photo,
                                            color: text,
                                            size: 40,
                                          )),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Ink(
                          color: button,
                          child: InkWell(
                            splashColor: container,
                            onTap: () async {
                              if (titleController.text != '' ||
                                  descController.text != '') {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseStorage _storage =
                                    FirebaseStorage.instance;
                                await _storage
                                    .ref(
                                        '${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}')
                                    .putFile(File(image.path))
                                    .then((value) async {
                                  String url = await value.ref.getDownloadURL();
                                  var res = await PostService.createPost(Post(
                                    byUserName: currentUser.displayName!,
                                    title: titleController.text,
                                    desc: descController.text,
                                    imageUrl: url,
                                    byUser: currentUser.uid,
                                  ));

                                  if (res) {
                                    setState(() {
                                      titleController.text = '';
                                      descController.text = '';
                                      imageCaptured = false;
                                      loading = false;
                                    });
                                    showSnack(
                                        content: 'Post Added',
                                        context: context);
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showSnack(
                                        content: 'Something went wrong',
                                        context: context);
                                  }
                                });
                                setState(() {
                                  loading = false;
                                });
                              } else {
                                showSnack(
                                    content: 'Please fill all the fields',
                                    context: context);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // color: button,
                                  ),
                              child: Center(
                                child: CustomText(
                                  content: 'Add Post',
                                  size: 20,
                                  color: text,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                if (loading)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: container,
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomText(content: 'loading...', color: text),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
