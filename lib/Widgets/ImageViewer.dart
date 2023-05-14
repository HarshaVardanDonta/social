// ignore_for_file: prefer_const_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:socail/const.dart';

class ImageViewer extends StatefulWidget {
  String url;
  ImageViewer({super.key, required this.url});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  image: widget.url,
                  placeholder: 'assets/tom.jpg',
                  placeholderFit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 400),
                  fadeOutCurve: Curves.easeOut,
                  fadeOutDuration: Duration(milliseconds: 400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
