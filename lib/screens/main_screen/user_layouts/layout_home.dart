import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_post.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class LayoutHome extends StatefulWidget {
  @override
  _LayoutHomeState createState() => _LayoutHomeState();
}

class _LayoutHomeState extends State<LayoutHome>{
  String myID = FirebaseAuth.instance.currentUser!.uid;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: postsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          print(snapshot.data!.docs);

          if (snapshot.data != null) {

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

            posts = [];


            for (var doc in snapshot.data!.docs){
              Post post = Post.fromMap(doc.data() as Map<String, dynamic>);
              posts.add(post);

            }


            return (posts.length > 0)
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ItemPost(post: posts[index]);
                    })
                : NotFound(message: "No posts yet");
          }

          return NotFound(message: "No Data");
        },
      ),
    );
  }

}
