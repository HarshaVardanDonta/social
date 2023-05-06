import 'package:flutter/material.dart';
import 'package:socail/Models/User.dart';
import 'package:socail/Network/FriendService.dart';
import 'package:socail/Network/UserService.dart';

import '../Widgets/CustomText.dart';
import '../const.dart';

class FriendChip extends StatefulWidget {
  String uid;
  String name;
  FriendChip({
    super.key,
    required this.uid,
    required this.name,
  });

  @override
  State<FriendChip> createState() => _FriendChipState();
}

class _FriendChipState extends State<FriendChip> {
  UserObj? currentDbUser;
  String? avatar;
  bool init = false;

  initUser() async {
    currentDbUser = await UserService.getUser();
    avatar = await UserService.getAvatar(widget.uid);
    setState(() {
      init = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      initUser();
      return Container();
    }
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(avatar!),
        ),
        title: CustomText(
          content: widget.name,
          size: 20,
          weight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
