import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/comment_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/comment_reply_listener.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'item_replied_comment.dart';

class CommentBubble extends StatefulWidget {
  Comment comment;
  DocumentReference postRef;
  CommentReplyListener commentReplyListener;

  @override
  _CommentBubbleState createState() => _CommentBubbleState();

  CommentBubble({
    required this.comment,
    required this.postRef,
    required this.commentReplyListener,
  });
}

class _CommentBubbleState extends State<CommentBubble>
    implements CommentInfoListener, BarberInfoListener, UserDataChangeListener {
  String post_time = "";
  Timer? timer;
  List<Comment> replies = [];
  late var commentUser;

  @override
  void initState() {
    commentUser = widget.comment.isBarber
        ? RegisteredUser(
            user_id: "user_id",
            firstName: "User",
            lastName: "",
            email: "",
            phone: "",
            password: "",
            image_url: "",
            country_code: "",
            notification_token: "",
            lastSeen: 0)
        : Barber(
            barber_id: "barber_id",
            firstName: "Stylist",
            lastName: "",
            email: "",
            phone: "",
            password: "",
            image_url: "",
            country_code: "",
            latitude: 0,
            longitude: 0,
            notification_token: "",
            avg_rating: 5,
            verified: false,
            lastSeen: 0,
            license_image: "");

    listenCommentInfoChanges(widget.postRef, widget.comment.comment_id, this);
    widget.comment.isBarber
        ? checkForBarberInfo(widget.comment.user_id, this)
        : checkForUserInfo(widget.comment.user_id, this);

    setState(() {
      post_time = convertTimeToText(widget.comment.timestamp, "ago");
    });
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSeconds());



    super.initState();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        post_time = convertTimeToText(widget.comment.timestamp, "ago");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color(0xF0EBEBEB),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Column(
                        children: [
                          CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  NetworkImage(commentUser.image_url)),
                          Text(
                            post_time,
                            style: grey_h6Style,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      title: Row(
                        children: [
                          Text(
                            (commentUser.firstName +
                                ' ' +
                                commentUser.lastName),
                            overflow: TextOverflow.ellipsis,
                            style: normal_h3Style_bold,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Visibility(
                                visible: widget.comment.isBarber,
                                child: ImageIcon(
                                  AssetImage('assets/razor.png'),
                                  size: 20,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ),
                      subtitle: SelectableText(
                        "${widget.comment.text}",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          switch (value) {
                            case 'reply':
                              widget.commentReplyListener.onCommentReplyPressed(
                                  widget.comment,
                                  commentUser.firstName +
                                      " " +
                                      commentUser.lastName);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'reply',
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.quickreply)),
                                Text('Reply'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.report)),
                                Text('Report'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            replies.length > 0
                ? AnimatedContainer(
                    duration: Duration(seconds: 1),
                    margin: EdgeInsets.only(
                        top: 5, left: MediaQuery.of(context).size.width * 0.2),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: replies.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Comment com = replies[index];
                        return ReplyCommentBubble(
                          comment: com,
                        );
                        // );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  checkForNewSeconds() {
    if (mounted){
      setState(() {
        post_time = convertTimeToText(widget.comment.timestamp, "ago");
      });
    }
  }

  @override
  void commentRepliesListener(List<Comment> replies) {
    setState(() {
      this.replies = replies;
    });
  }

  @override
  void dataReceived(RegisteredUser? registeredUser) {
    setState(() {
      this.commentUser = registeredUser!;
    });
  }

  @override
  void followedByMe(bool followed) {
    // TODO: implement followedByMe
  }

  @override
  void onBarberInfoChanged(Barber barber) {
    setState(() {
      this.commentUser = barber;
    });
  }

  @override
  void onFollowersChanged(int followers) {
    // TODO: implement onFollowersChanged
  }

  @override
  void onPostsCountChanged(int posts) {
    // TODO: implement onPostsCountChanged
  }
}
