// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Models/Friend.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/FriendService.dart';
import 'package:socail/Network/UserService.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  bool gotallUsers = false;
  bool gotPending = false;
  bool gotExisting = false;
  List<UserObj> allUsers = [];
  List<Friend> pendingRequests = [];
  List<Friend> existingFriends = [];
  getAllUsers() async {
    allUsers = await UserService.allUsers();
    setState(() {
      gotallUsers = true;
    });
  }

  getAllPendingRequests() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("disp : ${user!.displayName}");

    pendingRequests = await FriendService.getPendingRequests(user.uid);
    setState(() {
      gotPending = true;
    });
  }

  getExistingFriends() async {
    User? user = FirebaseAuth.instance.currentUser;
    existingFriends = await FriendService.getFriends(user!.uid);
    print(" existing friends : $existingFriends");
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (!gotallUsers) {
      getAllUsers();
    }
    if (!gotPending) {
      getAllPendingRequests();
    }
    if (!gotExisting) {
      getExistingFriends();
    }

    return Scaffold(
      backgroundColor: back,
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: 'All Users',
              ),
              Tab(
                text: 'Invitations',
              ),
              Tab(
                text: 'Your Friends',
              ),
            ],
            labelStyle: GoogleFonts.poppins(
              fontSize: 18,
              color: text,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                  child: ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CustomText(
                          content: allUsers[index].name,
                          size: 20,
                          weight: FontWeight.bold,
                          color: text,
                        ),
                        subtitle: CustomText(
                          content: allUsers[index].email,
                          size: 15,
                          weight: FontWeight.bold,
                          color: text,
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            var status = await FriendService.addFriend(
                                user!.uid, allUsers[index].firebaseUid);
                            if (status == 'Request already exists') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Request already exists'),
                                ),
                              );
                            } else if (status == "You can't add yourself") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You can't add yourself"),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: text,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CustomText(
                          content: pendingRequests[index].userName,
                          size: 20,
                          weight: FontWeight.bold,
                          color: text,
                        ),
                        subtitle: CustomText(
                          content: pendingRequests[index].friendUserName,
                          size: 15,
                          weight: FontWeight.bold,
                          color: text,
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await FriendService.acceptReq(
                              user!.uid,
                              pendingRequests[index].friendUserId,
                            );
                          },
                          icon: Icon(
                            Icons.done,
                            color: text,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    itemCount: existingFriends.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CustomText(
                          content: existingFriends[index].userName,
                          size: 20,
                          weight: FontWeight.bold,
                          color: text,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
