// ignore_for_file: file_names, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:socail/const.dart';

import '../Models/User.dart';

class UserService {
  static saveToken({
    required String token,
  }) async {
    var data = {
      "fid": FirebaseAuth.instance.currentUser!.uid,
      "token": token,
    };
    var response = await http.post(
      Uri.parse('$base_url/user/saveToken'),
      body: data,
    );

    print('token res is ${response.body}');
  }

  static Future<String> getToken({String? fid}) async {
    String firebaseId = FirebaseAuth.instance.currentUser!.uid;
    var response = await http
        .get(Uri.parse('$base_url/user/getToken/${fid ?? firebaseId}'));

    print('token res is ${response.body}');
    if (response.body != '') {
      return response.body;
    } else {
      return '';
    }
  }

  static registerUser(UserObj user) async {
    var data = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'firebaseUid': user.firebaseUid,
      'avatar': user.avatar,
      'fcm': user.fcm,
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
        .get(Uri.parse('${base_url}/user/getUser/${userFId ?? firebaseId}'));
    if (response.body != '') {
      UserObj user = UserObj.fromJson(json.decode(response.body));
      return user;
    } else {
      throw Exception('unable to load user');
    }
  }

  static Future<List<UserObj>> allUsers() async {
    String firebaseId = FirebaseAuth.instance.currentUser!.uid;
    var response = await http.get(Uri.parse('${base_url}/user/allUsers'));

    List<UserObj> allUsers;
    allUsers = (json.decode(response.body) as List)
        .map((e) => UserObj.fromJson(e))
        .toList();
    allUsers.removeWhere((element) => element.firebaseUid == firebaseId);

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

  static getAvatar(String firebaseUid) async {
    var response =
        await http.get(Uri.parse('$base_url/user/getAvatar/$firebaseUid'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }
}
