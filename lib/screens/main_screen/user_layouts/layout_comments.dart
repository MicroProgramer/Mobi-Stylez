import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/enums/needed.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/comment_reply_listener.dart';
import 'package:firebase_auth_practice/item_layouts/item_comment.dart';
import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class LayoutComment extends StatefulWidget {
  DocumentReference postRef;

  LayoutComment({required this.postRef});

  @override
  _LayoutCommentState createState() => _LayoutCommentState();
}

class _LayoutCommentState extends State<LayoutComment>
    implements CommentReplyListener {
  TextEditingController commentController = TextEditingController();
  String reply_user = "";
  late Comment replyingComment;
  bool showReplyRow = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.postRef.collection("comments").snapshots(),
          builder: (context, snapshots) {

            List<Step> steps = [];
            List<Comment> comments = [];

            for (var doc in snapshots.data!.docs){
              Comment com = Comment.fromMap(
                  doc.data() as Map<String, dynamic>);
              comments.add(com);
              steps.add(Step(title: Container(), content: CommentBubble(
                commentReplyListener: this,
                comment: com,
                postRef: widget.postRef,
              )));
            }


            return Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Comments",
                                  style: white_h2Style_bold,
                                )),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                tooltip: "Close",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        color: Colors.redAccent,
                        // boxShadow: [
                        //   BoxShadow(offset: Offset(0, 0), color: Colors.black12, blurRadius: .5, spreadRadius: 2)
                        // ]
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: (snapshots.data!.docs.length > 0)
                        ?
                    ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            // physics: PageScrollPhysics(),
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc =
                                  snapshots.data!.docs[index];
                              Comment com = Comment.fromMap(
                                  doc.data() as Map<String, dynamic>);
                              return CommentBubble(
                                commentReplyListener: this,
                                comment: com,
                                postRef: widget.postRef,
                              );
                              // );
                            },
                          )
                        : NotFound(message: 'No comments yet'),
                  ),
                  Column(
                    children: [
                      Visibility(
                        visible: showReplyRow,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Replying to ",
                                style: normal_h3Style,
                              ),
                              Text(
                                "$reply_user",
                                style: normal_h3Style_bold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  child: Text(
                                    "cancel",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showReplyRow = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        color: Colors.redAccent,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: TextFormField(
                                        // textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                        minLines: 1,
                                        autofocus: true,
                                        onChanged: (value) {},
                                        controller: commentController,
                                        style: TextStyle(fontSize: 17),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              right: 5,
                                              top: 10,
                                              bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom),
                                          hintText: "Write your comment",
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                              color: Color(0xF06B6B6B),
                                              fontSize: 17),
                                          border: OutlineInputBorder(
                                            gapPadding: 0,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            gapPadding: 0,
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
                                child: GestureDetector(
                                  child: Image.asset("assets/send_btn.png"),
                                  onTap: () {
                                    String commentText =
                                        commentController.text.trim();
                                    if (commentText.isNotEmpty) {
                                      int timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      Comment comment = Comment(
                                          timestamp: timestamp,
                                          user_id: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          comment_id: timestamp,
                                          text: commentText,
                                          isBarber: false);
                                      DocumentReference newCommentRef = widget
                                          .postRef
                                          .collection("comments")
                                          .doc("$timestamp");

                                      if (showReplyRow) {
                                        newCommentRef = widget.postRef
                                            .collection("comments")
                                            .doc(
                                                "${replyingComment.comment_id}")
                                            .collection("replies")
                                            .doc("$timestamp");
                                      }

                                      newCommentRef
                                          .set(comment.toMap())
                                          .then((value) {
                                        setState(() {
                                          showReplyRow = false;
                                          commentController.text = "";
                                        });
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void onCommentReplyPressed(Comment comment, String name) {
    replyingComment = comment;
    setState(() {
      showReplyRow = true;
      reply_user = name;
    });
  }
}
