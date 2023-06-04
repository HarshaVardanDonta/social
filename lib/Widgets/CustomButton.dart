// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

class CustomElevatedButtom extends StatefulWidget {
  String content;
  FontWeight? weight;
  Function() onPressed;
  CustomElevatedButtom(
      {super.key, required this.content, this.weight, required this.onPressed});

  @override
  State<CustomElevatedButtom> createState() => Custom_ElevatedButtomState();
}

class Custom_ElevatedButtomState extends State<CustomElevatedButtom> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: button,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: widget.onPressed,
        child: CustomText(
          color: text,
          content: widget.content,
          size: 20,
          weight: widget.weight ?? FontWeight.normal,
        ));
  }
}
