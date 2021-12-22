import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_inbox.dart';
import 'package:firebase_auth_practice/models/message_dummy.dart';
import 'package:firebase_auth_practice/screens/chat_screen.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class LayoutInbox extends StatefulWidget {
  @override
  _LayoutInboxState createState() => _LayoutInboxState();
}

class _LayoutInboxState extends State<LayoutInbox> {
  String myID = "";
  List<MessageDummy> messageDummies = [];

  @override
  void initState() {
    myID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(top: 15),
        child: StreamBuilder<QuerySnapshot>(
            stream: usersRef
                .doc(myID)
                .collection("chats")
                .orderBy('timestamp', descending: true)
                .snapshots(),
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

              log("messages ${snapshot.data!.docs.length}");

              messageDummies = [];
              for (var doc in snapshot.data!.docs) {
                MessageDummy dummy =
                    MessageDummy.fromMap(doc.data() as Map<String, dynamic>);
                messageDummies.add(dummy);
                print("dummy: ${doc.data()}");
              }

              return snapshot.data!.docs.length > 0
                  ? ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ItemInbox(
                            barber_id: messageDummies[index].barber_id,
                            last_message: messageDummies[index].last_message,
                            timestamp: messageDummies[index].timestamp,
                          ),
                          onTap: () {
                            openScreen(
                                context,
                                ChatScreen(
                                  barber_id: messageDummies[index].barber_id,
                                ));
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                        );
                      },
                    )
                  : NotFound(message: "No messages");
            }));
  }
}
