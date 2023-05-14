// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

class AllLikes extends StatefulWidget {
  final List likes;
  AllLikes({super.key, required this.likes});

  @override
  State<AllLikes> createState() => _AllLikesState();
}

class _AllLikesState extends State<AllLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: ListView.builder(
          itemCount: widget.likes.length,
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
                    content: widget.likes[index].userName,
                    color: text,
                    size: 25,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
