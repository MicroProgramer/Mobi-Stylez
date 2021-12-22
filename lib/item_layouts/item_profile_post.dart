import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/widgets/image_full_screen_wrapper.dart';
import 'package:flutter/material.dart';

class ItemProfilePost extends StatefulWidget {

  Post post;


  @override
  _ItemProfilePostState createState() => _ItemProfilePostState();

  ItemProfilePost({
    required this.post,
  });
}

class _ItemProfilePostState extends State<ItemProfilePost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 2)],
            image: DecorationImage(
                image: NetworkImage(widget.post.media_url), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () {
          openScreen(
              context,
              ImageFullScreenWrapperWidget(
                child: Image.network(widget.post.media_url),
                dark: true,
              ));
        },
      ),
    );
  }
}
