// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, await_only_futures, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Models/Friend.dart';
import 'package:socail/Models/Post.dart';
import 'package:socail/Network/Notification.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Screens/CameraScreen.dart';
import 'package:socail/Screens/VideoScreen.dart';
import 'package:socail/Widgets/CustomSnackbar.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';
import 'package:video_player/video_player.dart';

import '../Models/User.dart';
import '../Network/FriendService.dart';
import '../Network/UserService.dart';

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
late VideoPlayerController _controller;
bool isVideoPlaying = false;

class _AddPostState extends State<AddPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    imageCaptured = false;
    super.dispose();
  }

  bool gotExisting = false;
  UserObj? currentDbUser;
  List<Friend> existingFriends = [];
  getExistingFriends() async {
    currentDbUser = await UserService.getUser();
    existingFriends =
        await FriendService.getFriends(currentDbUser!.firebaseUid);
    setState(() {
      gotExisting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotExisting) {
      getExistingFriends();
      return Scaffold(
        backgroundColor: back,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
                              // color: button,
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
                                        child: (image.path.contains('mp4'))
                                            ? Stack(
                                                children: [
                                                  Center(
                                                    child: AspectRatio(
                                                        aspectRatio: _controller
                                                            .value.aspectRatio,
                                                        child: VideoPlayer(
                                                            _controller)),
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .bottomCenter,
                                                                end: Alignment.topCenter,
                                                                colors: [
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.8),
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.0)
                                                            ])),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // video progress indicator
                                                            VideoProgressIndicator(
                                                              _controller,
                                                              allowScrubbing:
                                                                  true,
                                                              colors:
                                                                  VideoProgressColors(
                                                                playedColor:
                                                                    text,
                                                                bufferedColor: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                                backgroundColor:
                                                                    back.withOpacity(
                                                                        0.2),
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  _controller.seekTo(
                                                                      Duration(
                                                                          seconds:
                                                                              0));
                                                                  setState(() {
                                                                    if (_controller
                                                                        .value
                                                                        .isPlaying) {
                                                                      _controller
                                                                          .pause();
                                                                    } else {
                                                                      _controller
                                                                          .play();
                                                                    }
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                  (_controller
                                                                          .value
                                                                          .isPlaying)
                                                                      ? Icons
                                                                          .pause
                                                                      : Icons
                                                                          .play_arrow,
                                                                  color: text,
                                                                  size: 30,
                                                                )),
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              )
                                            : Image.file(
                                                File(image.path),
                                                fit: BoxFit.cover,
                                              ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CamerScreen()))
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    image = value;
                                                    imageCaptured = true;
                                                    // loading = true;
                                                  });
                                                }
                                              });
                                            },
                                            child: Center(
                                                child: Icon(
                                              Icons.add_a_photo,
                                              color: text,
                                              size: 40,
                                            )),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();

                                              await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VideoScreen()))
                                                  .then((value) async {
                                                if (value != null) {
                                                  setState(() {
                                                    image = value;
                                                    imageCaptured = true;
                                                  });
                                                } 

                                                _controller =
                                                    VideoPlayerController.file(
                                                        File(image.path))
                                                      ..initialize().then((_) {
                                                        setState(() {});
                                                      });
                                                setState(() {
                                                  _controller.initialize();
                                                });
                                              });
                                            },
                                            child: Center(
                                                child: Icon(
                                              Icons.video_collection,
                                              color: text,
                                              size: 40,
                                            )),
                                          ),
                                        ],
                                      ),
                              ),
                              if (imageCaptured)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imageCaptured = false;
                                      image = XFile('');
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                        content: "Remove",
                                        color: text,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.delete, color: text, size: 20),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Ink(
                          // color: button,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: container,
                            onTap: () async {
                              if (titleController.text != '' &&
                                  descController.text != '' &&
                                  imageCaptured) {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseStorage _storage =
                                    FirebaseStorage.instance;
                                if (image.path.contains('mp4')) {
                                  await _storage
                                      .ref(
                                          '${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.mp4')
                                      .putFile(File(image.path))
                                      .then((value) async {
                                    String url =
                                        await value.ref.getDownloadURL();
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
                                      print(existingFriends);
                                      existingFriends.forEach((element) async {
                                        String token =
                                            await UserService.getToken(
                                                fid: (currentUser.uid ==
                                                        element.userId)
                                                    ? element.friendUserId
                                                    : element.userId);
                                        await sendPushMEssage(
                                            token,
                                            currentUser.displayName!,
                                            "${currentUser.displayName!} added a new video");
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
                                } else {
                                  await _storage
                                      .ref(
                                          '${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}')
                                      .putFile(File(image.path))
                                      .then((value) async {
                                    String url =
                                        await value.ref.getDownloadURL();
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
                                      print(existingFriends);
                                      existingFriends.forEach((element) async {
                                        String token =
                                            await UserService.getToken(
                                                fid: (currentUser.uid ==
                                                        element.userId)
                                                    ? element.friendUserId
                                                    : element.userId);
                                        await sendPushMEssage(
                                            token,
                                            currentUser.displayName!,
                                            "${currentUser.displayName!} added a new post");
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
                                }

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
