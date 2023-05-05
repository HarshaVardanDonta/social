// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/UserService.dart';
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
    DateFormat dateFormat = DateFormat();
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(builder: (context) {
                        return CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(widget.comments[index].avatar),
                        );
                      }),
                      SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        content: widget.comments[index].userName,
                        color: text,
                        size: 20,
                      ),
                    ],
                  ),
                  CustomText(
                    content: widget.comments[index].comment,
                    color: text,
                    size: 25,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    content: dateFormat.add_yMMMEd().add_jm().format(
                        DateTime.parse(widget.comments[index].createdDate)),
                    color: text,
                    size: 15,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
