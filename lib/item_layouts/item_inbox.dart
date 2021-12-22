import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:flutter/material.dart';

class ItemInbox extends StatefulWidget {
  @override
  _ItemInboxState createState() => _ItemInboxState();

  String barber_id;
  int timestamp;
  String last_message;

  ItemInbox({
    required this.barber_id,
    required this.timestamp,
    required this.last_message,
  });
}

class _ItemInboxState extends State<ItemInbox> implements BarberInfoListener {
  Barber barber = Barber(
      barber_id: "barber_id",
      firstName: "Stylist",
      lastName: "lastName",
      email: "email",
      phone: "phone",
      password: "password",
      image_url: "",
      country_code: "",
      latitude: 0,
      longitude: 0,
      notification_token: "",
      avg_rating: 5,
      verified: false,
      license_image: "",
      lastSeen: 0);
  String myID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    checkForBarberInfo(widget.barber_id, this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(barber.image_url),
      ),
      title: Text(
        barber.firstName + " " + barber.lastName,
        style: normal_h3Style_bold,
      ),
      subtitle: Text(
        widget.last_message,
        style: TextStyle(
          color: hintColor,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeStampToDateTime(widget.timestamp, "hh:mm a"),
            style: TextStyle(color: Colors.grey[500]),
          ),
          Text(
            timeStampToDateTime(widget.timestamp, "EEE dd, yyyy"),
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
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
  void onPostsCountChanged(int posts) {}
}
