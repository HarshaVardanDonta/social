// ignore_for_file: file_names, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';

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

  static Future<UserObj> getUser() async {
    var response = await http.get(Uri.parse('${base_url}/users/1'));
    if (response.statusCode == 200) {
      return UserObj.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
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
}
