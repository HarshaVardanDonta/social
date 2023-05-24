import 'package:flutter/material.dart';
import 'package:socail/Widgets/PostWidget.dart';

import '../Models/Post.dart';

class IndiPost extends StatefulWidget {
  Post post;
  IndiPost({super.key, required this.post});

  @override
  State<IndiPost> createState() => _IndiPostState();
}

class _IndiPostState extends State<IndiPost> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PostWidget(
        id: widget.post.id!,
        title: widget.post.title,
        desc: widget.post.desc,
        url: widget.post.imageUrl,
        user: widget.post.byUser,
        userName: widget.post.byUserName,
      ),
    );
  }
}
