import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/item_layouts/message_bubble.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/message.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
  String barber_id;

  ChatScreen({
    required this.barber_id,
  });
}

class _ChatScreenState extends State<ChatScreen> implements BarberInfoListener {
  ScrollController controller = ScrollController();
  double topContainer = 0;
  String myID = FirebaseAuth.instance.currentUser!.uid;
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
      license_image: "",
      lastSeen: 0);

  var messageController = TextEditingController();

  @override
  void initState() {
    checkForBarberInfo(widget.barber_id, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainerDesign(
      appBar: AppBar(
        elevation: 0,
        title: Text("Chat"),
      ),
      paddingTop: 0,
      child: StreamBuilder<QuerySnapshot>(
        stream: usersRef
            .doc(myID)
            .collection("chats")
            .doc(widget.barber_id)
            .collection("messages")
            .snapshots(),
        builder: (context, snapshot) {
          List<Message> messages = [];
          for (var doc in snapshot.data!.docs) {
            messages.add(Message.fromMap(doc.data() as Map<String, dynamic>));
          }

          controller.animateTo(messages.length * 50,
              duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    openScreen(
                        context,
                        StylistProfileScreen(
                          barber_id: barber.barber_id,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "stylist_dp",
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(barber.image_url),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            barber.firstName + " " + barber.lastName,
                            style: normal_h3Style_bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: snapshot.data!.docs.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: messages.length,
                        controller: controller,
                        itemBuilder: (context, index) {
                          Message message = messages[index];
                          bool sender = (message.sender_id == myID);
                          return MessageBubble(
                            timestamp: message.timestamp,
                            text: message.text,
                            userType: sender ? Type.sender : Type.receiver,
                          );
                          // );
                        },
                      )
                    : NotFound(message: "No messages yet"),
              ),
              Container(
                color: Colors.redAccent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: TextFormField(
                                // textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: messageController,
                                onChanged: (value) {},
                                style: TextStyle(fontSize: 17),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 15, right: 5, top: 10, bottom: 10),
                                  hintText: "Write your message",
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                      color: Color(0xF06B6B6B), fontSize: 17),
                                  border: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
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
                            onTap: () {
                              String text = messageController.text.trim();
                              if (text.isNotEmpty) {
                                int id = DateTime.now().millisecondsSinceEpoch;
                                Message message = Message(
                                    id: id.toString(),
                                    timestamp: id,
                                    sender_id: myID,
                                    receiver_id: barber.barber_id,
                                    text: text);

                                usersRef
                                    .doc("$myID/chats/${barber.barber_id}")
                                    .set({
                                  "timestamp": message.timestamp,
                                  "last_message": message.text,
                                  "barber_id": barber.barber_id
                                }).then((value) {
                                  usersRef
                                      .doc(
                                          "$myID/chats/${barber.barber_id}/messages/$id")
                                      .set(message.toMap())
                                      .then((value) {
                                    setState(() {
                                      messageController.text = "";
                                    });
                                  });

                                  barbersRef
                                      .doc("${barber.barber_id}/chats/$myID")
                                      .set({
                                    "timestamp": message.timestamp,
                                    "last_message": message.text,
                                    "user_id": myID
                                  }).then((value) {
                                    barbersRef
                                        .doc(
                                            "${barber.barber_id}/chats/${myID}/messages/$id")
                                        .set(message.toMap());
                                  });
                                }).catchError((error, stackTrace) {
                                  showSnackBar(error.toString(), context);
                                });
                              }
                            },
                            child: Image.asset("assets/send_btn.png")),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void followedByMe(bool followed) {
    // TODO: implement followedByMe
  }

  @override
  void onBarberInfoChanged(Barber barber) {
    setState(() {
      this.barber = barber;
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
