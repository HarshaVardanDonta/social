// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  String content;
  double? size;
  Color? color;
  FontWeight? weight;

  CustomText(
      {super.key, required this.content, this.size, this.color, this.weight});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      style: GoogleFonts.poppins(
        fontSize: widget.size,
        color: widget.color,
        fontWeight: widget.weight,
      ),
    );
  }
}
