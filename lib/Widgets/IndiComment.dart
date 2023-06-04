import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socail/Models/Comment.dart';

import '../Network/UserService.dart';
import '../const.dart';
import 'CustomText.dart';

class IndiComment extends StatefulWidget {
  Comment comment;
  IndiComment({super.key, required this.comment});

  @override
  State<IndiComment> createState() => _IndiCommentState();
}

class _IndiCommentState extends State<IndiComment> {
  String? avatar;
  bool avatarLoad = false;

  getAvatar() async {
    avatar = await UserService.getAvatar(widget.comment.userId);
    setState(() {
      avatarLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!avatarLoad) {
      getAvatar();
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: button,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                return CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(avatar!),
                );
              }),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                content: widget.comment.userName,
                color: text,
                size: 20,
              ),
            ],
          ),
          CustomText(
            content: widget.comment.comment,
            color: text,
            size: 25,
            weight: FontWeight.bold,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            content: dateFormat
                .add_yMMMEd()
                .add_jm()
                .format(DateTime.parse(widget.comment.createdDate)),
            color: text,
            size: 15,
          ),
        ],
      ),
    );
  }

  DateFormat dateFormat = DateFormat();
}
