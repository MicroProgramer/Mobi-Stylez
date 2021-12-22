import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/post_info_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/models/follower.dart';
import 'package:firebase_auth_practice/models/like.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/models/report.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_comments.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:firebase_auth_practice/widgets/expandable_text.dart';
import 'package:firebase_auth_practice/widgets/image_full_screen_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ItemPost extends StatefulWidget {
  Post post;

  @override
  _ItemPostState createState() => _ItemPostState();

  ItemPost({
    required this.post,
  });
}

class _ItemPostState extends State<ItemPost>
    implements PostInfoListener, BarberInfoListener {
  late bool liked;
  String post_time = "";
  Timer? timer;
  int totalComments = 0;
  int totalLikes = 0;
  String myId = "";
  bool reportedPost = false;
  bool following = false;
  Barber barber = Barber(
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
  bool hidePost = false;
  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      post_time = convertTimeToText(widget.post.timestamp, "ago");
      listenPostInfoChanges(widget.post.post_id, this);
      timer = Timer.periodic(
          Duration(seconds: 2), (Timer t) => checkForNewSeconds());
      myId = FirebaseAuth.instance.currentUser!.uid;
      liked = false;
      checkForBarberInfo(widget.post.barber_id, this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xF0E0E0E0),
            boxShadow: [BoxShadow(blurRadius: 5)]),
        child: Column(
          children: [
            Visibility(
              visible: !hidePost,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        openScreen(
                            context,
                            StylistProfileScreen(
                              barber_id: widget.post.barber_id,
                            ));
                      },
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(barber.image_url)),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            barber.firstName + " " + barber.lastName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GestureDetector(
                              child: Text(
                                following ? "Following" : "Follow",
                                textAlign: TextAlign.center,
                                style: following ? grey_h4Style : red_h4Style,
                              ),
                              onTap: () {
                                setState(() {
                                  bool action = !following;
                                  DocumentReference followerDoc = barbersRef
                                      .doc(widget.post.barber_id)
                                      .collection("followers")
                                      .doc(myId);
                                  if (action) {
                                    Follower followerObj =
                                        Follower(user_id: myId);
                                    followerDoc.set(followerObj.toMap());
                                  } else {
                                    followerDoc.delete();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(widget.post.address),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        switch (value) {
                          case 'report':
                            if (!reportedPost) {
                              showOptionsDialog(
                                  context: context,
                                  title: "Select a Reason",
                                  actions: [
                                    'Unwanted Content',
                                    'Hate Speech',
                                    'Others'
                                  ],
                                  onSelected: (value) {
                                    Report report = Report(
                                        user_id: myId,
                                        post_id: widget.post.post_id,
                                        report_description: value,
                                        timestamp: DateTime.now()
                                            .millisecondsSinceEpoch);

                                    postsRef
                                        .doc(widget.post.post_id)
                                        .collection("reports")
                                        .doc(
                                            "${DateTime.now().millisecondsSinceEpoch}")
                                        .set(report.toMap())
                                        .then((value) => showSnackBar(
                                            "Reported Successfully", context));
                                  });
                            }

                            break;
                          case 'hide':
                            setState(() {
                              showLoading = true;
                            });

                            postsRef
                                .doc(widget.post.post_id)
                                .collection('hiddenFor')
                                .doc(myId)
                                .set({"user_id": myId}).then((value) {
                              setState(() {
                                showLoading = false;
                              });
                            }).catchError((error) {
                              showSnackBar(error.toString(), context);
                            });
                            break;

                          case 'block':
                            usersRef
                                .doc(myId)
                                .collection('blocked_barbers')
                                .doc(widget.post.barber_id)
                                .set({
                              'barber_id': "${widget.post.barber_id}"
                            }).then((value) {
                              showSnackBar('Barber Blocked', context);
                            });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'hide',
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.hide_image_outlined)),
                                Text('Hide'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.report)),
                                Text(reportedPost
                                    ? "Already Reported"
                                    : 'Report'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'block',
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.block)),
                                Text("Block Stylist"),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      child: ExpandableText(
                        widget.post.description,
                        trimLines: 4,
                      ),
                      onTap: () {
                        // showSnackBar("Description of item ${widget.index}", context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                        widget.post.media_url))),
                          )),
                      onTap: () {
                        // showSnackBar("Image of item ${widget.index}", context);
                        openScreen(
                            context,
                            ImageFullScreenWrapperWidget(
                              child: Image.network(widget.post.media_url),
                              dark: true,
                            ));
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // showSnackBar("Like of item ${widget.index}", context);
                          setState(() {
                            print("like pressed");
                            bool likeAction = !liked;
                            String postId = widget.post.post_id;
                            DocumentReference likeDoc = postsRef
                                .doc(postId)
                                .collection("likes")
                                .doc(myId);
                            if (likeAction) {
                              Like likeObj = Like(user_id: myId);
                              likeDoc.set(likeObj.toMap());
                            } else {
                              likeDoc.delete();
                            }
                          });
                        },
                        icon: ImageIcon(
                          AssetImage("assets/unliked.png"),
                          color: liked ? Colors.deepOrange : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheetMenu(
                            context: context,
                            content: LayoutComment(
                                postRef: postsRef.doc(widget.post.post_id)),
                          );
                        },
                        icon: ImageIcon(
                          AssetImage("assets/comment.png"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: TextFormField(
                            onTap: () {
                              showModalBottomSheetMenu(
                                context: context,
                                content: LayoutComment(
                                    postRef: postsRef.doc(widget.post.post_id)),
                              );
                            },
                            // textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: 12),
                            readOnly: true,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 5, right: 5),
                              hintText: "Write your comment",
                              hintStyle: TextStyle(
                                  color: Color(0xF06B6B6B), fontSize: 12),
                              border: OutlineInputBorder(
                                gapPadding: 0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xF0707070)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  gapPadding: 0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xF0707070))),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: ImageIcon(
                            AssetImage('assets/mailbox.png'),
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          usersRef
                              .doc(myId)
                              .collection('saved_posts')
                              .doc(widget.post.post_id)
                              .set(widget.post.toMap())
                              .then((value) {
                            showSnackBar("Post added to saved items", context);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "$totalLikes likes",
                                style: normal_h4Style_bold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "$totalComments comments",
                                  style: normal_h4Style_bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              openScreen(
                                  context,
                                  StylistProfileScreen(
                                    barber_id: widget.post.barber_id,
                                    layout_index: 1,
                                  ));
                            },
                            child: Text("Book now"),
                            style: redButtonProfileStyle_small,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(post_time),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: hidePost,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Post hidden",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      postsRef
                          .doc(widget.post.post_id)
                          .collection('hiddenFor')
                          .doc(myId)
                          .delete();
                    },
                    child: Text(
                      "Undo",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.red[100],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  checkForNewSeconds() {
    if (mounted && !hidePost) {
      setState(() {
        post_time = convertTimeToText(widget.post.timestamp, "ago");
      });
    }
  }

  @override
  void updatedCommentsListener(List<Comment> comments) {
    if (mounted && !hidePost) {
      setState(() {
        totalComments = comments.length;
      });
    }
  }

  @override
  void updatedLikesListener(List<Like> likes) {
    if (mounted && !hidePost) {
      totalLikes = likes.length;
      for (Like like in likes) {
        if (like.user_id == myId) {
          setState(() {
            liked = true;
            return;
          });
        }
      }

      setState(() {
        liked = false;
      });
    }
  }

  @override
  void updatedPostListener(Post post) {}

  @override
  void updatedReportsListener(List<Report> reports) {
    if (mounted && !hidePost) {
      for (Report report in reports) {
        if (report.user_id == myId) {
          reportedPost = true;
        }
      }
    }
  }

  @override
  void onBarberInfoChanged(Barber barber) {
    if (mounted && !hidePost) {
      setState(() {
        this.barber = barber;
      });
    }
  }

  @override
  void onFollowersChanged(int followers) {}

  @override
  void followedByMe(bool followed) {
    if (mounted && !hidePost) {
      setState(() {
        following = followed;
      });
    }
  }

  @override
  void onPostsCountChanged(int posts) {
    // TODO: implement onPostsCountChanged
  }

  @override
  void hiddenForUsers(List<String> users) {
    if (mounted) {
      if (users.contains(myId)) {
        setState(() {
          hidePost = true;
        });
      } else {
        setState(() {
          hidePost = false;
        });
      }
    }
  }

// }

}
