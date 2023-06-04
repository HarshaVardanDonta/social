// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socail/Models/FriendChip.dart';
import 'package:socail/Screens/ChatPage.dart';
import 'package:socail/Screens/HomePage.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

import '../Models/Friend.dart';
import '../Models/User.dart';
import '../Network/FriendService.dart';
import '../Network/UserService.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  List<Friend> existingFriends = [];
  bool gotExisting = false;
  UserObj? currentDbUser;
  getExistingFriends() async {
    currentDbUser = await UserService.getUser();
    existingFriends =
        await FriendService.getFriends(currentDbUser!.firebaseUid);
    setState(() {
      gotExisting = true;
    });
  }

  checkDocExists({
    required Friend friend,
  }) async {
    String docName;
    var doc = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc('${friend.userId}-${friend.friendUserId}')
        .get();
    if (!doc.exists) {
      docName = '${friend.friendUserId}-${friend.userId}';
    } else {
      docName = '${friend.userId}-${friend.friendUserId}';
    }
    return docName;
  }

  @override
  Widget build(BuildContext context) {
    if (!gotExisting) {
      getExistingFriends();
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: back,
        appBar: AppBar(
          backgroundColor: back,
          foregroundColor: text,
          elevation: 0,
          title: CustomText(
            content: "Chat",
            size: 20,
            weight: FontWeight.bold,
          ),
        ),
        drawer: Drawer(),
        body: SafeArea(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: existingFriends.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () async {
                  var docNAme =
                      await checkDocExists(friend: existingFriends[index]);
                  await FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(docNAme)
                      .set({
                    currentDbUser!.firebaseUid: true,
                    "users": [
                      existingFriends[index].friendUserId,
                      existingFriends[index].userId,
                    ]
                  }, SetOptions(merge: true)).then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  friend: existingFriends[index],
                                )));
                  });
                },
                child: FriendChip(
                  name: (currentDbUser!.firebaseUid ==
                          existingFriends[index].userId)
                      ? existingFriends[index].friendUserName
                      : existingFriends[index].userName,
                  uid: (currentDbUser!.firebaseUid ==
                          existingFriends[index].userId)
                      ? existingFriends[index].friendUserId
                      : existingFriends[index].userId,
                ));
          },
        )),
      ),
    );
  }
}
