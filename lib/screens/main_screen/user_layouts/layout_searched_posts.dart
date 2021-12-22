import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_post.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class LayoutSearchedPosts extends StatefulWidget {
  String searchQuery;

  @override
  _LayoutSearchedPostsState createState() => _LayoutSearchedPostsState();

  LayoutSearchedPosts({
    required this.searchQuery,
  });
}

class _LayoutSearchedPostsState extends State<LayoutSearchedPosts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Post> posts = [];
        for (var doc in snapshot.data!.docs) {
          Post post = Post.fromMap(doc.data() as Map<String, dynamic>);
          if (widget.searchQuery.isEmpty || post.description.toLowerCase().contains(widget.searchQuery)){
            posts.add(post);
          }
        }

        return posts.length > 0
            ? ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return ItemPost(post: posts[index]);
                },
              )
            : NotFound(
                message: "No Posts found for \"${widget.searchQuery}\"");
      },
    );
  }
}
