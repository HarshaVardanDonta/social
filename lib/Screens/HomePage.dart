// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/Notification.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Screens/AddPost.dart';
import 'package:socail/Screens/Feed.dart';
import 'package:socail/Screens/Friends.dart';
import 'package:socail/Screens/Login.dart';
import 'package:socail/Widgets/CustomBottombutton.dart';
import 'package:socail/Widgets/CustomButton.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

import '../Widgets/CustomSnackbar.dart';
import 'Explore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> body = [
    Feed(),
    Explore(),
    AddPost(),
    Friends(),
  ];
  int activePage = 0;
  PageController pageController = PageController();
  bool homeSelected = true;
  bool exploreSelected = false;

  bool addSelected = false;
  bool friendsSelected = false;
  UserObj? dbUser;
  getUser() async {
    dbUser = await UserService.getUser();
    setState(() {
      gotUser = true;
    });
  }

  bool showLoading = false;

  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    await UserService.saveToken(token: token!);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initInfo() async {
    var androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = DarwinInitializationSettings();
    var settings = InitializationSettings(android: androidSettings, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (response) async {
      print(response);
    }, onDidReceiveBackgroundNotificationResponse: (response) async {
      print(response);
    });
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('......................on message.......................');
      print('${message.notification!.title} and ${message.notification!.body}');
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        '${message.notification!.body}',
        htmlFormatBigText: true,
        contentTitle: '${message.notification!.title}',
        htmlFormatContentTitle: true,
        // summaryText: 'Chat',
        htmlFormatSummaryText: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );
      DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: iosDetails);
      await flutterLocalNotificationsPlugin.show(
          0,
          '${message.notification!.title}',
          '${message.notification!.body}',
          notificationDetails,
          payload: message.data['body']);
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    initInfo();
  }

  bool gotUser = false;
  List<String> titles = [
    'Home',
    'Explore',
    'Add Post',
    'Friends',
  ];
  @override
  Widget build(BuildContext context) {
    if (!gotUser) {
      getUser();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: button,
          ),
        ),
      );
    }
    return Stack(
      children: [
        Scaffold(
            drawer: Drawer(
              backgroundColor: container,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 68,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(dbUser!.avatar ??
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: button,
                            child: IconButton(
                              onPressed: () async {
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          backgroundColor: container,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                iconSize: 30,
                                                onPressed: () async {
                                                  ImagePicker picker =
                                                      ImagePicker();
                                                  var pickedImage =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 20);
                                                  if (pickedImage == null) {
                                                  } else {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      showLoading = true;
                                                    });
                                                    FirebaseStorage _storage =
                                                        FirebaseStorage
                                                            .instance;
                                                    await _storage
                                                        .ref(
                                                            'avatars/${currentUser!.uid}')
                                                        .putFile(File(
                                                            pickedImage.path))
                                                        .then((value) async {
                                                      String url = await value
                                                          .ref
                                                          .getDownloadURL();
                                                      var status =
                                                          await UserService
                                                              .setProfile(url);
                                                      if (status) {
                                                        setState(() {
                                                          getUser();
                                                          showLoading = false;
                                                        });
                                                        showSnack(
                                                            content:
                                                                'Profile picture updated',
                                                            context: context);
                                                      } else {
                                                        showSnack(
                                                            content:
                                                                'Unable to update profile picture',
                                                            context: context);
                                                      }
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: text,
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 30,
                                                onPressed: () async {
                                                  ImagePicker picker =
                                                      ImagePicker();
                                                  var pickedImage =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 20);
                                                  if (pickedImage == null) {
                                                  } else {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      showLoading = true;
                                                    });
                                                    FirebaseStorage _storage =
                                                        FirebaseStorage
                                                            .instance;
                                                    await _storage
                                                        .ref(
                                                            'avatars/${currentUser!.uid}')
                                                        .putFile(File(
                                                            pickedImage.path))
                                                        .then((value) async {
                                                      String url = await value
                                                          .ref
                                                          .getDownloadURL();
                                                      var status =
                                                          await UserService
                                                              .setProfile(url);
                                                      if (status) {
                                                        setState(() {
                                                          getUser();
                                                          showLoading = false;
                                                        });
                                                        showSnack(
                                                            content:
                                                                'Profile picture updated',
                                                            context: context);
                                                      } else {
                                                        showSnack(
                                                            content:
                                                                'Unable to update profile picture',
                                                            context: context);
                                                      }
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.image_outlined,
                                                  color: text,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.edit,
                                color: text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      content: dbUser!.name,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomElevatedButtom(
                        content: 'Sign out',
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Login())));
                        }),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              foregroundColor: text,
              backgroundColor: back,
              elevation: 0,
              title: CustomText(
                content: titles[activePage],
                color: text,
                weight: FontWeight.bold,
                size: 20,
              ),
            ),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  activePage = index;
                });
              },
              children: body,
            ),
            backgroundColor: back,
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(8),
              height: 90,
              decoration: BoxDecoration(
                color: container,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBottombutton(
                        selected: homeSelected,
                        icon: Icons.home,
                        content: 'Home',
                        onPressed: () {
                          setState(() {
                            homeSelected = true;
                            exploreSelected = false;
                            addSelected = false;
                            friendsSelected = false;
                            activePage = 0;
                            pageController.animateToPage(0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          });
                        },
                      ),
                      CustomBottombutton(
                        selected: exploreSelected,
                        icon: Icons.explore,
                        content: 'Explore',
                        onPressed: () {
                          setState(() {
                            exploreSelected = true;
                            addSelected = false;
                            homeSelected = false;
                            friendsSelected = false;
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          });
                        },
                      ),
                      CustomBottombutton(
                        selected: addSelected,
                        icon: Icons.add,
                        content: 'Add',
                        onPressed: () {
                          setState(() {
                            addSelected = true;
                            exploreSelected = false;
                            homeSelected = false;
                            friendsSelected = false;
                            activePage = 1;
                            pageController.animateToPage(2,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          });
                        },
                      ),
                      CustomBottombutton(
                        selected: friendsSelected,
                        icon: Icons.people,
                        content: 'Friends',
                        onPressed: () {
                          setState(() {
                            friendsSelected = true;
                            exploreSelected = false;
                            homeSelected = false;
                            addSelected = false;
                            activePage = 2;
                            pageController.animateToPage(3,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
        if (showLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              width: 200,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: button,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
