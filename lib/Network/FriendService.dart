// ignore_for_file: unused_local_variable

import 'package:socail/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socail/Models/Friend.dart';

class FriendService {
  static addFriend(String userId, String friendUserId) async {
    var data = {
      'userId': userId,
      'friendUserId': friendUserId,
    };
    var response = await http.post(
      Uri.parse('$base_url/friend/add'),
      body: data,
    );
    return response.body;
  }

  static Future<List<Friend>> getPendingRequests(String userId) async {
    var res =
        await http.get(Uri.parse('$base_url/friend/pendingRequests/$userId'));
    if (res.statusCode == 200) {
      List<Friend> friends = [];
      var data = json.decode(res.body);
      for (var friend in data) {
        friends.add(Friend.fromJson(friend));
      }
      return friends;
    } else {
      return [];
    }
  }

  static acceptReq(String userId, String friendUserId) async {
    var data = {
      'userId': userId,
      'friendUserId': friendUserId,
    };
    var response = await http.post(
      Uri.parse('$base_url/friend/acceptRequest'),
      body: data,
    );
  }

  static Future<List<Friend>> getFriends(String userId) async {
    var response = await http.get(
      Uri.parse('$base_url/friend/friends/$userId'),
    );

    if (response.statusCode == 200) {
      List<Friend> friends = [];
      var data = json.decode(response.body);
      for (var friend in data) {
        friends.add(Friend.fromJson(friend));
      }
      return friends;
    } else {
      List<Friend> friends = [];

      return friends;
    }
  }
}
