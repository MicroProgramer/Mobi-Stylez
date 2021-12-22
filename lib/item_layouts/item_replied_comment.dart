import 'dart:async';

import 'package:firebase_auth_practice/enums/needed.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyCommentBubble extends StatefulWidget {
  Comment comment;

  ReplyCommentBubble({required this.comment});

  @override
  _ReplyCommentBubbleState createState() => _ReplyCommentBubbleState();
}

class _ReplyCommentBubbleState extends State<ReplyCommentBubble>
    implements BarberInfoListener, UserDataChangeListener {
  String post_time = "";
  Timer? timer;

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
      padding: const EdgeInsets.all(3.0),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Color(0xF0EBEBEB),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Column(
                        children: [
                          CircleAvatar(
                              radius: 16,
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
                            commentUser.firstName + " " + commentUser.lastName,
                            overflow: TextOverflow.ellipsis,
                            style: normal_h4Style_bold,
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
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      // trailing: PopupMenuButton<String>(
                      //   onSelected: (String value) {
                      //     showSnackBar(value, context);
                      //   },
                      //   itemBuilder: (BuildContext context) =>
                      //   <PopupMenuEntry<String>>[
                      //     PopupMenuItem<String>(
                      //       value: 'report',
                      //       child: Row(
                      //         children: [
                      //           IconButton(
                      //               onPressed: () {}, icon: Icon(Icons.report)),
                      //           Text('Report'),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkForNewSeconds() {
    setState(() {
      post_time = convertTimeToText(widget.comment.timestamp, "ago");
    });
  }

  String getUserInfoById(String user_id, Needed needed) {
    for (RegisteredUser user in allUsersList) {
      if (user.user_id == user_id) {
        switch (needed) {
          case Needed.name:
            return user.firstName + " " + user.lastName;
            break;
          case Needed.image_url:
            return user.image_url;
            break;
        }
      }
    }
    switch (needed) {
      case Needed.name:
        return "Unknown User";
        break;
      case Needed.image_url:
        return test_image;
        break;
    }
  }

  @override
  void dataReceived(RegisteredUser? registeredUser) {
    if (mounted){
      setState(() {
        commentUser = registeredUser;
      });
    }
  }

  @override
  void followedByMe(bool followed) {
    // TODO: implement followedByMe
  }

  @override
  void onBarberInfoChanged(Barber barber) {
    if (mounted){
      setState(() {
        commentUser = barber;
      });
    }
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
