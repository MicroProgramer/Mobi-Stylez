import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/chat_screen.dart';
import 'package:firebase_auth_practice/screens/stylist_profile/stylist_profile_book_appointment_layout.dart';
import 'package:firebase_auth_practice/screens/stylist_profile/stylist_profile_confirmed_appoinntments_layout.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:firebase_auth_practice/widgets/custom_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StylistProfileAppointmentsScreen extends StatefulWidget {
  String barber_id;
  Slot slot;

  double amount;

  @override
  _StylistProfileAppointmentsScreenState createState() =>
      _StylistProfileAppointmentsScreenState();

  StylistProfileAppointmentsScreen({
    required this.barber_id,
    required this.slot,
    required this.amount,
  });
}

class _StylistProfileAppointmentsScreenState
    extends State<StylistProfileAppointmentsScreen>
    with TickerProviderStateMixin
    implements BarberInfoListener {
  late Barber barber;

  int followers = 0;

  int posts = 0;

  @override
  void initState() {
    barber = Barber(
        barber_id: widget.barber_id,
        firstName: "Stylist Name",
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
                              child: Image.network(barber.image_url),
                              backgroundColor: Colors.transparent,
                              radius: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              "${barber.firstName} ${barber.lastName}",
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
                              posts.toString(),
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
                                    onPressed: () {},
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: redButtonProfileStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: ElevatedButton(
                            onPressed: () {},
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
                      rating: 3,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
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
                    tabs_titles_list: [
                      "Book Appointment",
                      "Confirmed Appointments"
                    ],
                    tabController: TabController(length: 2, vsync: this),
                    tab_children_layouts: [
                      StylistProfileBookAppointmentLayout(
                        slot: widget.slot,
                        amount: widget.amount,
                      ),
                      StylistProfileConfirmedAppointmentsLayout(barber_id: widget.barber_id,)
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
    setState(() {
      this.followers = followers;
    });
  }

  @override
  void onPostsCountChanged(int posts) {
    setState(() {
      this.posts = posts;
    });
  }
}
