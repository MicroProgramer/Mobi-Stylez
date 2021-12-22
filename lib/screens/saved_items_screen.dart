import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_profile_post.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({Key? key}) : super(key: key);

  @override
  _SavedItemsScreenState createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  String myID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainerDesign(
      paddingTop: 10,
      appBar: AppBar(
        title: Text("Saved Posts"),
        elevation: 0,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: usersRef.doc(myID).collection('saved_posts').snapshots(),
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
              : NotFound(message: "No Saved Posts");
        },
      ),
    );
  }
}
