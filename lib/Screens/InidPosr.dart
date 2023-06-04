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
import 'package:socail/Widgets/CustomSnackbar.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/Widgets/ImageViewer.dart';

import '../Widgets/IndiComment.dart';
import '../const.dart';

class IndiPost extends StatefulWidget {
  int id;
  String title;
  String desc;
  String url;
  String user;
  String userName;
  CallbackAction? callbackAction;
  // List<Like> likes;
  IndiPost({
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
  State<IndiPost> createState() => _IndiPostState();
}

class _IndiPostState extends State<IndiPost> {
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
    comments.clear();
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

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: back,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: Row(
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
                      Column(
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
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    content: 'u/${widget.userName}',
                    color: text,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 400,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: back,
                      border: Border.all(
                        color: text,
                        width: 1,
                      ),
                    ),
                    child: GestureDetector(
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
                                    content: 'Already Liked', context: context);
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
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return IndiComment(
                        comment: comments[index],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
