// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socail/Models/Post.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Screens/CameraScreen.dart';
import 'package:socail/Widgets/CustomButton.dart';
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

    return Scaffold(
      backgroundColor: back,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTExtField(
                            controller: titleController, hint: 'Title'),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTExtField(
                            controller: descController, hint: 'Description'),
                        SizedBox(
                          height: 10,
                        ),
                        CustomElevatedButtom(
                            content: 'Add Image',
                            onPressed: () async {
                              if (titleController.text != '' ||
                                  descController.text != '') {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CamerScreen())).then((value) {
                                  setState(() {
                                    image = value;
                                    imageCaptured = true;
                                    loading = true;
                                  });
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Post added successfully')));
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Something went wrong')));
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please fill all the fields')));
                              }
                            }),
                        // IconButton(
                        //     onPressed: () async {
                        //       if (titleController.text != '' ||
                        //           descController.text != '') {
                        //         image = await controller!.takePicture();

                        //         setState(() {
                        //           imageCaptured = true;
                        //           loading = true;
                        //         });

                        //         FirebaseStorage _storage =
                        //             FirebaseStorage.instance;
                        //         await _storage
                        //             .ref(
                        //                 '${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}')
                        //             .putFile(File(image.path))
                        //             .then((value) async {
                        //           String url = await value.ref.getDownloadURL();
                        //           var res = await PostService.createPost(Post(
                        //             title: titleController.text,
                        //             desc: descController.text,
                        //             imageUrl: url,
                        //             byUser: currentUser.uid,
                        //           ));

                        //           if (res) {
                        //             setState(() {
                        //               titleController.text = '';
                        //               descController.text = '';
                        //               imageCaptured = false;
                        //               loading = false;
                        //             });
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //                 SnackBar(
                        //                     content: Text(
                        //                         'Post added successfully')));
                        //           } else {
                        //             setState(() {
                        //               loading = false;
                        //             });
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //                 SnackBar(
                        //                     content:
                        //                         Text('Something went wrong')));
                        //           }
                        //         });
                        //       } else {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //             SnackBar(
                        //                 content: Text(
                        //                     'Please fill all the fields')));
                        //       }
                        //     },
                        //     icon: Icon(
                        //       Icons.camera_alt,
                        //       size: 30,
                        //       color: text,
                        //     )),
                      ]),
                  if (loading)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
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
      ),
    );
  }
}
