// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socail/Network/Notification.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/const.dart';

import '../Models/Friend.dart';
import '../Models/User.dart';
import '../Network/UserService.dart';

class ChatPage extends StatefulWidget {
  Friend friend;
  ChatPage({super.key, required this.friend});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  DateFormat dateFormat = DateFormat("dd MMM yyyy HH:mm a");
  UserObj? currentDbUser;

  bool gotCurrent = false;
  initCurrentUser() async {
    currentDbUser = await UserService.getUser();
    setState(() {
      gotCurrent = true;
    });
  }

  late String docName;
  bool gotDoc = false;
  checkDocExists() async {
    var doc = await FirebaseFirestore.instance
        .collection("chat")
        .doc('${widget.friend.userId}-${widget.friend.friendUserId}')
        .get();
    if (!doc.exists) {
      docName = '${widget.friend.friendUserId}-${widget.friend.userId}';
    } else {
      docName = '${widget.friend.userId}-${widget.friend.friendUserId}';
    }
    setState(() {
      gotDoc = true;
    });
  }

  String chatDocName = '';
  checkChatRoomExists() async {
    var doc = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc('${widget.friend.userId}-${widget.friend.friendUserId}')
        .get();
    if (!doc.exists) {
      chatDocName = '${widget.friend.friendUserId}-${widget.friend.userId}';
    } else {
      chatDocName = '${widget.friend.userId}-${widget.friend.friendUserId}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!gotCurrent) {
      initCurrentUser();
      return Scaffold(
        backgroundColor: back,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!gotDoc) {
      checkDocExists();
      return Scaffold(
        backgroundColor: back,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          await checkChatRoomExists();
          await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(docName)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(chatDocName)
                .set({currentDbUser!.firebaseUid: false},
                    SetOptions(merge: true));
          });
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: back,
            foregroundColor: text,
            elevation: 0,
            title: CustomText(
                content: (currentDbUser!.name == widget.friend.friendUserName)
                    ? widget.friend.userName
                    : widget.friend.friendUserName),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          backgroundColor: back,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chat')
                        .doc(docName)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: (snapshot.data!.docs[index]
                                            ['sender'] ==
                                        currentDbUser!.firebaseUid)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment:
                                      (snapshot.data!.docs[index]['sender'] ==
                                              currentDbUser!.firebaseUid)
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: (snapshot.data!.docs[index]
                                                    ['sender'] ==
                                                currentDbUser!.firebaseUid)
                                            ? container
                                            : button,
                                        borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(10),
                                            topRight: const Radius.circular(10),
                                            bottomLeft: (snapshot
                                                            .data!.docs[index]
                                                        ['sender'] ==
                                                    currentDbUser!.firebaseUid)
                                                ? const Radius.circular(10)
                                                : const Radius.circular(0),
                                            bottomRight: (snapshot
                                                            .data!.docs[index]
                                                        ['sender'] ==
                                                    currentDbUser!.firebaseUid)
                                                ? const Radius.circular(0)
                                                : const Radius.circular(10)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: (snapshot.data!
                                                    .docs[index]['sender'] ==
                                                currentDbUser!.firebaseUid)
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            content: snapshot.data!.docs[index]
                                                ['content'],
                                            size: 16,
                                            weight: FontWeight.w500,
                                            color: (snapshot.data!.docs[index]
                                                        ['sender'] ==
                                                    currentDbUser!.firebaseUid)
                                                ? Colors.white
                                                : text,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            content: dateFormat.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    snapshot.data!.docs[index]
                                                        ['time'])),
                                            size: 10,
                                            weight: FontWeight.w500,
                                            color: text.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }

                      return Container();
                    })),
              )),
              // StreamBuilder(
              //   stream: FirebaseFirestore.instance
              //       .collection("chat")
              //       .doc(docName)
              //       .snapshots(),
              //   builder: (context, snapshot) {},
              // ),
              TextFormField(
                controller: messageController,
                style: GoogleFonts.poppins(color: text),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: text),
                  fillColor: back,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("chat")
                          .doc(docName)
                          .collection('messages')
                          .add({
                        "content": messageController.text.toString(),
                        "sender":
                            (currentDbUser!.firebaseUid == widget.friend.userId)
                                ? widget.friend.userId
                                : currentDbUser!.firebaseUid,
                        "receiver":
                            (currentDbUser!.firebaseUid != widget.friend.userId)
                                ? widget.friend.userId
                                : currentDbUser!.firebaseUid,
                        "time": DateTime.now().millisecondsSinceEpoch,
                      }).then((value) async {
                        String token = await UserService.getToken(
                            fid: (currentDbUser!.firebaseUid !=
                                    widget.friend.userId)
                                ? widget.friend.userId
                                : widget.friend.friendUserId);
                        await checkChatRoomExists();
                        await FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(chatDocName)
                            .get()
                            .then((value) async {
                          var data = jsonEncode(value.data()!);
                          var jsonData = jsonDecode(data);
                          print(jsonData);
                          var friendId = (currentDbUser!.firebaseUid !=
                                  widget.friend.userId)
                              ? widget.friend.userId
                              : widget.friend.friendUserId;
                          if (jsonData['$friendId'] == false) {
                            await sendPushMEssage(
                                token,
                                "New message from ${(currentDbUser!.firebaseUid == widget.friend.userId) ? widget.friend.userName : currentDbUser!.name}",
                                messageController.text.toString());
                          }
                        });

                        messageController.clear();
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
