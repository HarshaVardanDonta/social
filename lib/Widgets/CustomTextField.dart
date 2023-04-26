// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/const.dart';

class CustomTExtField extends StatefulWidget {
  TextEditingController controller;
  String hint;
  bool? isPassword;

  CustomTExtField({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword,
  });

  @override
  State<CustomTExtField> createState() => _CustomTExtFieldState();
}

class _CustomTExtFieldState extends State<CustomTExtField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        style: GoogleFonts.poppins(fontSize: 15, color: text),
        obscureText: widget.isPassword ?? false,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: text, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: text, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: text, width: 1),
          ),
          hintText: widget.hint,
          // label: Text(
          //   widget.hint,
          //   style: GoogleFonts.poppins(fontSize: 15, color: text),
          // ),
          hintStyle: GoogleFonts.poppins(fontSize: 15, color: text),
        ));
  }
}
