// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socail/Screens/InidPosr.dart';
import 'package:socail/Widgets/CustomText.dart';

import '../Models/Post.dart';
import '../Network/PostService.dart';
import '../const.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  List<Post> feed = [];

  search(String query) async {
    feed.clear();
    feed = await PostService().searchPost(
      searchQuery: query,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      search(value);
                    },
                    controller: _searchController,
                    style: GoogleFonts.poppins(color: text, fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      hintText: 'Type to search...',
                      hintStyle: TextStyle(color: text, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchQuery = '';
                        feed.clear();
                      });
                    },
                    icon: Icon(
                      (_searchController.text.isEmpty)
                          ? Icons.search
                          : Icons.clear,
                      color: text,
                    )),
              ],
            ),
            Divider(
              color: text,
            ),
            (_searchController.text.isNotEmpty && feed.isEmpty)
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 100,
                          color: text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          content: "No results found for \"${searchQuery}\"",
                          size: 20,
                          color: text,
                        ),
                      ],
                    ),
                  )
                : (_searchController.text.isEmpty && feed.isEmpty)
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 100,
                              color: text,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomText(
                              content: "Type to search",
                              size: 20,
                              color: text,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.custom(
                            physics: BouncingScrollPhysics(),
                            gridDelegate: SliverQuiltedGridDelegate(
                              crossAxisCount: 3,
                              repeatPattern: QuiltedGridRepeatPattern.inverted,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              pattern: [
                                QuiltedGridTile(2, 1),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                              ],
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                                childCount: feed.length, (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IndiPost(
                                                id: feed[index].id!,
                                                title: feed[index].title,
                                                desc: feed[index].desc,
                                                url: feed[index].imageUrl,
                                                user: feed[index].byUser,
                                                userName:
                                                    feed[index].byUserName,
                                              )));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/tom.jpg',
                                          image: feed[index].imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: back.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                                color: text,
                                                content: feed[index].title),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
