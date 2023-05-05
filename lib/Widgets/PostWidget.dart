// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, iterable_contains_unrelated_type, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Models/Comment.dart';
import 'package:socail/Models/Like.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/LikeService.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Screens/AllComments.dart';
import 'package:socail/Screens/AllLikes.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/CustomTextField.dart';
import 'package:socail/Widgets/ImageViewer.dart';

import '../const.dart';

class PostWidget extends StatefulWidget {
  int id;
  String title;
  String desc;
  String url;
  String user;
  String userName;
  List<Comment> comments;
  // List<Like> likes;
  PostWidget({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.url,
    required this.user,
    required this.comments,
    required this.userName,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool gotLikes = false;
  List<Like> likes = [];
  UserObj? postUser;

  getLikes() async {
    likes = await LikeService.getPostLikes(widget.id);
    postUser = await UserService.getUser(userFId: widget.user);
    setState(() {
      gotLikes = true;
    });
  }

  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!gotLikes) {
      getLikes();
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            color: button,
          ),
        ),
      );
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
                        radius: 25,
                        backgroundImage: NetworkImage(postUser!.avatar!),
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
                  CustomText(
                    content: 'By - ${widget.userName}',
                    color: text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 500,
                    child: Container(
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
                                var res = await LikeService.addLike(
                                    widget.id, widget.user);
                                if (res == "saved") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Liked")));
                                } else if (res == "already liked") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("already liked")));
                                }
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
                                      builder: ((context) => AllComments(
                                          comments: widget.comments))));
                            },
                            icon: Icon(
                              Icons.comment,
                              color: text,
                            ),
                          ),
                          CustomText(
                            content: '${widget.comments.length}',
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
                            DateTime createdDate = DateTime.now();
                            var status = await PostService.addComment(
                              id: widget.id,
                              comment: commentController.text,
                              byUser: widget.user,
                              avatar: postUser!.avatar!,
                              userName: widget.userName,
                              createdDate: createdDate.toString(),
                            );
                            if (status) {
                              commentController.clear();
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Comment Added')));
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
