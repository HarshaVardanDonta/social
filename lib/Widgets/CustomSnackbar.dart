// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:socail/const.dart';

import 'CustomText.dart';

showSnack({
  required String content,
  required BuildContext context,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: container,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: CustomText(
          content: content,
          color: text,
          weight: FontWeight.bold,
        )),
  );
}
