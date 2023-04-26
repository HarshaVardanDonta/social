// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

class CustomBottombutton extends StatelessWidget {
  Function() onPressed;
  IconData icon;
  String content;
  bool selected;
  CustomBottombutton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.content,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? button : container,
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          splashColor: text,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 60,
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected ? text : back,
                  size: 30,
                ),
                SizedBox(
                  height: 5,
                ),
                CustomText(
                  content: content,
                  color: selected ? text : back,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
