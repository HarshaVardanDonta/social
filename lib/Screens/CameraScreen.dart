// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:socail/const.dart';

import '../Widgets/CustomText.dart';

class CamerScreen extends StatefulWidget {
  const CamerScreen({super.key});

  @override
  State<CamerScreen> createState() => _CamerScreenState();
}

class _CamerScreenState extends State<CamerScreen> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  bool init = false;
  late XFile image;
  bool isFrontCam = false;

  initCam() async {
    _cameras = await availableCameras();
    controller = await CameraController(_cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
    setState(() {
      init = true;
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      initCam();
      return Scaffold(
          body: Column(
        children: [
          CustomText(
            content: 'Loading...',
            color: text,
            weight: FontWeight.bold,
            size: 25,
          ),
        ],
      ));
    }

    return Scaffold(
        backgroundColor: back,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller!.value.isInitialized)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: controller!.value.previewSize?.height,
                    width: controller!.value.previewSize?.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CameraPreview(controller!)),
                  ),
                ),
              if (!controller!.value.isInitialized)
                Expanded(
                  child: Container(
                    child: Center(
                      child: CustomText(
                        content: 'Loading...',
                        color: text,
                        weight: FontWeight.bold,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                // height: 100,
                decoration: BoxDecoration(
                    color: container,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          controller!.dispose();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: text,
                        )),
                    IconButton(
                        onPressed: () async {
                          try {
                            image = await controller!.takePicture();
                            Navigator.pop(context, image);
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(
                          Icons.camera,
                          color: text,
                        )),
                    if (!isFrontCam)
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              isFrontCam = true;
                              init = false;
                            });
                            controller!.dispose();
                            controller = await CameraController(
                                _cameras[1], ResolutionPreset.max);
                            controller!.initialize().then((_) {
                              setState(() {});
                            }).catchError((Object e) {
                              if (e is CameraException) {
                                switch (e.code) {
                                  case 'CameraAccessDenied':
                                    break;
                                  default:
                                    break;
                                }
                              }
                            });
                            setState(() {
                              init = true;
                            });
                          },
                          icon: Icon(
                            Icons.flip_camera_ios,
                            color: text,
                          )),
                    if (isFrontCam)
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              isFrontCam = false;
                              init = false;
                            });
                            controller!.dispose();
                            controller = await CameraController(
                                _cameras[0], ResolutionPreset.max);
                            controller!.initialize().then((_) {
                              setState(() {});
                            }).catchError((Object e) {
                              if (e is CameraException) {
                                switch (e.code) {
                                  case 'CameraAccessDenied':
                                    break;
                                  default:
                                    break;
                                }
                              }
                            });
                            setState(() {
                              init = true;
                            });
                          },
                          icon: Icon(
                            Icons.flip_camera_ios,
                            color: text,
                          ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
