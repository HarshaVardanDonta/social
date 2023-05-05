// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:socail/Models/Comment.dart';
import 'package:socail/Models/Post.dart';
import 'package:socail/Network/PostService.dart';
import 'package:socail/Widgets/CustomText.dart';
import 'package:socail/Widgets/PostWidget.dart';
import 'package:socail/const.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future<List<Post>> feed = PostService().getAllPosts();
  initFeed() async {
    feed = PostService().getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          initFeed();
        });
        return Future.value(true);
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Post>>(
                future: feed,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: text,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            content: snapshot.error.toString(),
                            color: text,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }
                  List<Post> posts = snapshot.data!;
                  if (posts.length == 0) {
                    return Center(
                      child: CustomText(
                        content: 'No Posts yet',
                        color: text,
                        size: 20,
                      ),
                    );
                  }
                  posts.sort((a, b) => b.id!.compareTo(a.id!));
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<List<Comment>>(
                          future: PostService.getComments(posts[index].id!),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center();
                            }
                            return PostWidget(
                              userName: posts[index].byUserName,
                              id: posts[index].id!,
                              title: posts[index].title,
                              desc: posts[index].desc,
                              url: posts[index].imageUrl,
                              user: posts[index].byUser,
                              comments: snapshot.data!,
                            );
                          }));
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
