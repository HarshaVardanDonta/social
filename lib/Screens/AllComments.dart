// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socail/Widgets/CustomText.dart';
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
            return Container(
              decoration: BoxDecoration(
                color: button,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    content: widget.comments[index].comment,
                    color: text,
                    size: 25,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    content: "By - ${widget.comments[index].userId}",
                    color: text,
                    size: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
