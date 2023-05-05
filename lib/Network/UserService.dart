// ignore_for_file: file_names, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:socail/const.dart';

import '../Models/User.dart';

class UserService {
  static registerUser(UserObj user) async {
    var data = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'firebaseUid': user.firebaseUid,
      'avatar': user.avatar,
    };
    var response = await http.post(
      Uri.parse('$base_url/user/register'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json',
      // },
      body: data,
    );
    print('res is ${response.body}');
  }

  static getUser({String? userFId}) async {
    String firebaseId = FirebaseAuth.instance.currentUser!.uid;
    var response = await http
        .get(Uri.parse('${base_url}/user/findUser/${userFId ?? firebaseId}'));
    print(response.body);
    return UserObj.fromJson(json.decode(response.body));
  }

  static Future<List<UserObj>> allUsers() async {
    var response = await http.get(Uri.parse('${base_url}/user/allUsers'));

    List<UserObj> allUsers;
    allUsers = (json.decode(response.body) as List)
        .map((e) => UserObj.fromJson(e))
        .toList();

    return allUsers;
  }

  static getUserName({
    required String firebaseUid,
  }) async {
    var response =
        await http.get(Uri.parse('$base_url/user/findUser/$firebaseUid'));
    print(response.body);
    if (response.statusCode == 200) {
      return UserObj.fromJson(json.decode(response.body));
    } else {
      return UserObj(name: '', email: '', password: '', firebaseUid: '');
    }
  }

  static setProfile(String url) async {
    String firebaseId = FirebaseAuth.instance.currentUser!.uid;
    var data = {
      'url': url,
    };
    var response = await http.post(
      Uri.parse('$base_url/user/addAvatar/$firebaseId'),
      body: data,
    );
    print('res is ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
