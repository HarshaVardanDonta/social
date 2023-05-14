import 'dart:convert';

import 'package:socail/Models/Like.dart';
import 'package:socail/const.dart';
import 'package:http/http.dart' as http;

class LikeService {
  static addLike(int postId, String likedBy, String userName) async {
    var data = {
      'postId': postId.toString(),
      'byUser': likedBy,
      'userName': userName,
    };
    var response = await http.post(
      Uri.parse('$base_url/like/addLike'),
      body: data,
    );
    return response.body;
  }

  static Future<List<Like>> getPostLikes(int postId) async {
    var response = await http.get(
      Uri.parse('$base_url/like/getLikes/${postId.toString()}'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Like> likes = [];
      for (var like in data) {
        likes.add(Like.fromJson(like));
      }
      return likes;
    } else {
      return [];
    }
  }
}
