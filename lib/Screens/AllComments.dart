// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socail/Widgets/IndiComment.dart';
import 'package:socail/const.dart';

class AllComments extends StatefulWidget {
  final List comments;
  AllComments({super.key, required this.comments});

  @override
  State<AllComments> createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: ListView.builder(
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return IndiComment(
              comment: widget.comments[index],
            );
          }),
    );
  }
}
