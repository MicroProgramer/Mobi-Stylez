import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/barber_posts_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/follower.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/screens/appointments/available_slots_screen.dart';
import 'package:firebase_auth_practice/screens/stylist_profile/stylist_profile_posts_layout.dart';
import 'package:firebase_auth_practice/screens/stylist_profile/stylist_profile_services_layout.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:firebase_auth_practice/widgets/custom_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'chat_screen.dart';

class StylistProfileScreen extends StatefulWidget {
  String barber_id;
  String? slot_id;
  int? layout_index;

  @override
  _StylistProfileScreenState createState() => _StylistProfileScreenState();

  StylistProfileScreen(
      {required this.barber_id, this.slot_id, this.layout_index});
}

class _StylistProfileScreenState extends State<StylistProfileScreen>
    with TickerProviderStateMixin
    implements BarberPostsListener, BarberInfoListener {
  late TabController tabController;
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
  int totalPosts = 0;
  int followers = 0;

  bool following = false;

  String myId = "";

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    myId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      tabController.index = widget.layout_index ?? 0;
    });

    checkForBarberInfo(widget.barber_id, this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainerDesign(
      appBar: AppBar(
        elevation: 0,
        title: Text("Stylist Profile"),
      ),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Hero(
                            tag: "stylist_dp",
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(barber.image_url),
                              backgroundColor: Colors.transparent,
                              radius: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              barber.firstName + " " + barber.lastName,
                              style: normal_h3Style_bold,
                            ),
                          ),
                          Text(
                            "Hair Artist",
                            style: grey_h2Style_bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "$totalPosts",
                              textAlign: TextAlign.center,
                              style: normal_h2Style_bold,
                            )),
                            Expanded(
                                child: Text(
                              followers.toString(),
                              textAlign: TextAlign.center,
                              style: normal_h2Style_bold,
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Posts",
                              textAlign: TextAlign.center,
                              style: normal_h2Style,
                            )),
                            Expanded(
                                child: Text(
                              "Followers",
                              textAlign: TextAlign.center,
                              style: normal_h2Style,
                            ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      openScreen(
                                          context,
                                          ChatScreen(
                                            barber_id: widget.barber_id,
                                          ));
                                    },
                                    child: Text(
                                      "Message",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: redButtonProfileStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      bool action = !following;
                                      DocumentReference followerDoc = barbersRef
                                          .doc(widget.barber_id)
                                          .collection("followers")
                                          .doc(myId);
                                      if (action) {
                                        Follower followerObj =
                                            Follower(user_id: myId);
                                        followerDoc.set(followerObj.toMap());
                                      } else {
                                        followerDoc.delete();
                                      }
                                    },
                                    child: Text(
                                      following ? "Following" : "Follow",
                                      style: TextStyle(
                                          color: following
                                              ? Colors.red
                                              : Colors.white),
                                    ),
                                    style: following
                                        ? inverseRedButtonProfileStyle
                                        : redButtonProfileStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              openScreen(
                                  context,
                                  AvailableSlotScreen(
                                    barber_id: widget.barber_id,
                                  ));
                            },
                            child: Text(
                              "Available Slots",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: redButtonProfileStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "2 Rue de Ermesinde",
                  style: grey_h3Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Frisange - Luxembourg 3 km",
                  style: grey_h3Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: barber.avg_rating,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      //rating
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "(27)",
                        style: grey_h3Style,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: CustomTabBarView(
                    tabs_length: 2,
                    tabs_titles_list: ["Posts", "Services"],
                    tabController: tabController,
                    tab_children_layouts: [
                      StylistProfilePostsLayout(
                        barber_id: widget.barber_id,
                      ),
                      StylistProfileServicesLayout(
                        barber_id: widget.barber_id,
                        slot_id: widget.slot_id,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void postsByBarber(List<Post> posts) {
    setState(() {
      totalPosts = posts.length;
    });
  }

  @override
  void onBarberInfoChanged(Barber barber) {
    setState(() {
      this.barber = barber;
    });
  }

  @override
  void onFollowersChanged(int barberFollowers) {
    //
    setState(() {
      this.followers = barberFollowers;
    });
  }

  @override
  void followedByMe(bool followed) {
    // TODO: implement followedByMe
    setState(() {
      following = followed;
    });
  }

  @override
  void onPostsCountChanged(int posts) {
    setState(() {
      this.totalPosts = posts;
    });
  }
}
