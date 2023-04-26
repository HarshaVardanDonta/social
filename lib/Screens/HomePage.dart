// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socail/Screens/AddPost.dart';
import 'package:socail/Screens/Feed.dart';
import 'package:socail/Screens/Friends.dart';
import 'package:socail/Screens/Login.dart';
import 'package:socail/Widgets/CustomBottombutton.dart';
import 'package:socail/Widgets/CustomButton.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> body = [
    Feed(),
    AddPost(),
    Friends(),
  ];
  int activePage = 0;
  PageController pageController = PageController();
  bool homeSelected = true;
  bool addSelected = false;
  bool friendsSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: container,
          child: SafeArea(
            child: Column(
              children: [
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
        appBar: (activePage == 0)
            ? AppBar(
                foregroundColor: text,
                backgroundColor: back,
                elevation: 0,
                title: CustomText(
                  content: 'Home',
                  color: text,
                  weight: FontWeight.bold,
                  size: 25,
                ),
              )
            : (activePage == 1)
                ? null
                : AppBar(
                    foregroundColor: text,
                    backgroundColor: back,
                    elevation: 0,
                    title: CustomText(
                      content: 'Friends',
                      color: text,
                      weight: FontWeight.bold,
                      size: 25,
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
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                    selected: addSelected,
                    icon: Icons.add,
                    content: 'Add',
                    onPressed: () {
                      setState(() {
                        addSelected = true;
                        homeSelected = false;
                        friendsSelected = false;
                        activePage = 1;
                        pageController.animateToPage(1,
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
                        homeSelected = false;
                        addSelected = false;
                        activePage = 2;
                        pageController.animateToPage(2,
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
        ));
  }
}
