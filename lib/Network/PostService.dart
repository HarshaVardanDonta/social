import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socail/Models/Post.dart';
import 'package:socail/const.dart';

import '../Models/Comment.dart';

class PostService {
  static Future<bool> createPost(Post post) async {
    var data = {
      'title': post.title,
      'desc': post.desc,
      'imageUrl': post.imageUrl,
      'byUser': post.byUser,
      'byUserName': post.byUserName,
    };
    var response = await http.post(
      Uri.parse('$base_url/post/create'),
      body: data,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Post>> getAllPosts() {
    return http.get(Uri.parse('$base_url/post/all')).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException(
            'Unable to reach the Server, Please try after some time!');
      },
    ).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Post> posts =
            body.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw "Can't get posts";
      }
    });
  }

  searchPost({
    required String searchQuery,
  }) async {
    var res = await http.get(Uri.parse('$base_url/post/find/$searchQuery'));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  static Future<bool> addComment({
    required int id,
    required String comment,
    required String byUser,
    required String avatar,
    required String userName,
    required String createdDate,
  }) async {
    var data = {
      'postId': id.toString(),
      'comment': comment,
      'byUser': byUser,
      'userName': userName,
      'createdDate': createdDate,
    };
    var response = await http.post(
      Uri.parse('$base_url/comment/addComment'),
      body: data,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static getComments(int postId) {
    return http
        .get(Uri.parse('$base_url/comment/getComments/$postId'))
        .then((response) {
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Comment> comments =
            body.map((dynamic item) => Comment.fromJson(item)).toList();
        comments.sort((a, b) => b.id.compareTo(a.id));
        return comments;
      } else {
        throw "Can't get comments";
      }
    });
  }
}
