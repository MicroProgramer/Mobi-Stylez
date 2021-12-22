import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_profile_post.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StylistProfilePostsLayout extends StatefulWidget {
  String barber_id;

  @override
  _StylistProfilePostsLayoutState createState() =>
      _StylistProfilePostsLayoutState();

  StylistProfilePostsLayout({
    required this.barber_id,
  });
}

class _StylistProfilePostsLayoutState extends State<StylistProfilePostsLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            postsRef.where("barberID", isEqualTo: widget.barber_id).snapshots(),
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
            posts.add(post);
          }

          return posts.length > 0
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return ItemProfilePost(
                      post: posts[index],
                    );
                  },
                  itemCount: posts.length,
                )
              : NotFound(message: "No posts yet");
        });
  }
}
