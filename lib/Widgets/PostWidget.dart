// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, iterable_contains_unrelated_type, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Models/Comment.dart';
import 'package:socail/Models/Like.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/LikeService.dart';
import 'package:socail/Network/Notification.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Screens/AllComments.dart';
import 'package:socail/Screens/AllLikes.dart';
import 'package:socail/Screens/InidPosr.dart';
import 'package:socail/Widgets/CustomSnackbar.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/Widgets/ImageViewer.dart';
import 'package:video_player/video_player.dart';

import '../const.dart';

class PostWidget extends StatefulWidget {
  int id;
  String title;
  String desc;
  String url;
  String user;
  String userName;
  CallbackAction? callbackAction;
  // List<Like> likes;
  PostWidget({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.url,
    required this.user,
    required this.userName,
    this.callbackAction,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool gotLikes = false;
  bool gotComments = false;
  List<Like> likes = [];
  List<Comment> comments = [];
  UserObj? postUser;
  UserObj? dbUser;

  getDbUser() async {
    dbUser = await UserService.getUser();
  }

  getLikes() async {
    likes = await LikeService.getPostLikes(widget.id);
    postUser = await UserService.getUser(userFId: widget.user);
    setState(() {
      gotLikes = true;
    });
  }

  getComments() async {
    comments = await PostService.getComments(widget.id);
    setState(() {
      gotComments = true;
    });
  }

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  late VideoPlayerController _controller;
  bool videoInit = false;

  initVidController() {
    _controller = VideoPlayerController.network(
      widget.url,
    )..initialize().then((_) {});
    setState(() {
      videoInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!videoInit) {
      initVidController();
    }
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (!gotLikes) {
      getDbUser();
      getLikes();
      return Container();
    }
    if (!gotComments) {
      getComments();
      return Container();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: button,
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(postUser!.avatar!),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndiPost(
                                url: widget.url,
                                desc: widget.desc,
                                id: widget.id,
                                title: widget.title,
                                user: widget.user,
                                userName: widget.userName,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              content: widget.title,
                              color: text,
                              size: 20,
                              weight: FontWeight.bold,
                            ),
                            CustomText(
                              content: widget.desc,
                              color: text,
                              size: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  CustomText(
                    content: 'u/${widget.userName}',
                    color: text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 400,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: back,
                        border: Border.all(
                          color: text,
                          width: 1,
                        ),
                      ),
                      child: (widget.url.contains('mp4'))
                          ? Stack(
                              children: [
                                Center(
                                  child: AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller)),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.8),
                                                Colors.black.withOpacity(0.0)
                                              ])),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // video progress indicator
                                          VideoProgressIndicator(
                                            _controller,
                                            allowScrubbing: true,
                                            colors: VideoProgressColors(
                                              playedColor: container,
                                              bufferedColor:
                                                  Colors.white.withOpacity(0.5),
                                              backgroundColor:
                                                  back.withOpacity(0.2),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                // _controller.seekTo(
                                                //     Duration(seconds: 0));
                                                setState(() {
                                                  if (_controller
                                                      .value.isPlaying) {
                                                    _controller.pause();
                                                  } else {
                                                    _controller.play();
                                                    _controller.addListener(() {
                                                      if (_controller
                                                              .value.position ==
                                                          _controller
                                                              .value.duration) {
                                                        _controller.seekTo(
                                                            Duration(
                                                                seconds: 0));
                                                        _controller.pause();
                                                        setState(() {});
                                                      }
                                                    });
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                (_controller.value.isPlaying)
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: text,
                                                size: 30,
                                              )),
                                        ],
                                      ),
                                    ))
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                              url: widget.url,
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  imageErrorBuilder: (context, error, stack) {
                                    return Container(
                                      height: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: back,
                                        border: Border.all(
                                          color: text,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error,
                                            color: text,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomText(
                                            content:
                                                'Firebase Storage Quota Exceeded',
                                            color: text,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  image: widget.url,
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/tom.jpg',
                                  placeholderFit: BoxFit.cover,
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration: Duration(milliseconds: 400),
                                  fadeOutCurve: Curves.easeOut,
                                  fadeOutDuration: Duration(milliseconds: 400),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          AllLikes(likes: likes))));
                            },
                            child: IconButton(
                              onPressed: () async {
                                UserObj user = await UserService.getUser();
                                var res = await LikeService.addLike(
                                    widget.id, dbUser!.firebaseUid, user.name);
                                if (res == "saved") {
                                  showSnack(content: 'Liked', context: context);
                                  String token = await UserService.getToken(
                                      fid: widget.user);
                                  sendPushMEssage(token, "You got a like",
                                      '${widget.title} liked by ${dbUser!.name}');
                                } else if (res == "already liked") {
                                  showSnack(
                                      content: 'Already Liked',
                                      context: context);
                                }
                                setState(() {
                                  getLikes();
                                });
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: text,
                              ),
                            ),
                          ),
                          CustomText(
                            content: '${likes.length}',
                            color: text,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          AllComments(comments: comments))));
                            },
                            icon: Icon(
                              Icons.comment,
                              color: text,
                            ),
                          ),
                          CustomText(
                            content: '${comments.length}',
                            color: text,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: text,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              controller: commentController,
                              style: GoogleFonts.poppins(
                                color: text,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Comment',
                                hintStyle: GoogleFonts.poppins(
                                  color: text,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            )),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (commentController.text.isNotEmpty) {
                            UserObj? commentUser = await UserService.getUser();
                            DateTime createdDate = DateTime.now();
                            var status = await PostService.addComment(
                              id: widget.id,
                              comment: commentController.text,
                              byUser: commentUser!.firebaseUid,
                              avatar: commentUser.avatar.toString(),
                              userName: commentUser.name,
                              createdDate: createdDate.toString(),
                            );
                            if (status) {
                              FocusScope.of(context).unfocus();
                              showSnack(
                                  content: 'Comment Added', context: context);
                              setState(() {
                                getComments();
                              });
                              String token =
                                  await UserService.getToken(fid: widget.user);
                              sendPushMEssage(
                                  token,
                                  "New Comment on ${widget.title}",
                                  '${commentController.text} by ${commentUser.name}');
                              commentController.clear();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
