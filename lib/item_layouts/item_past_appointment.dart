import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/service_listener.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/service.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemPastAppointment extends StatefulWidget {
  Appointment appointment;


  @override
  _ItemPastAppointmentState createState() => _ItemPastAppointmentState();

  ItemPastAppointment({
    required this.appointment,
  });
}

class _ItemPastAppointmentState extends State<ItemPastAppointment>
    implements BarberInfoListener, ServiceListener {


  late Barber barber;
  late Service service;

  @override
  void initState() {
    barber = Barber(barber_id: widget.appointment.barber_id,
        firstName: "Stylist",
        lastName: "Name",
        email: "",
        phone: "",
        password: "",
        image_url: "",
        country_code: "",
        latitude: 0,
        longitude: 0,
        notification_token: "",
        avg_rating: 0,
        verified: false,
        license_image: "",
        lastSeen: 0);
    service = Service(service_id: widget.appointment.service_id,
        title: "Service",
        description: "",
        minPrice: 0,
        maxPrice: 0,
        image_url: "",
        barberID: widget.appointment.barber_id);
    checkForBarberInfo(widget.appointment.barber_id, this);
    checkForServiceInfo(widget.appointment.service_id, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(test_image),
                ),
                Text(
                  barber.firstName + " " + barber.lastName,
                  style: normal_h3Style_bold,
                ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 2)],
                  image: DecorationImage(
                      image: NetworkImage(service.image_url), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service.title,
                    style: normal_h2Style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    " ${doubleWithoutDecimalToInt(widget.appointment.paid_amount)} \$",
                    style: normal_h4Style_bold,
                  ),
                ],
              ),
              subtitle: Text(
                service.description,
                style: normal_h5Style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeStampToDateTime(widget.appointment.timestamp, "EEE, dd MMM"),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    timeStampToDateTime(widget.appointment.timestamp, "hh:mm a"),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Service has been provided",
              style: normal_h2Style_bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You want to ",
                  style: normal_h2Style,
                ),
                GestureDetector(
                  child: Text(
                    "book again?",
                    style: red_h2Style,
                  ),
                  onTap: () {
                    openScreen(context, StylistProfileScreen(barber_id: widget.appointment.barber_id, layout_index: 1,));
                  },
                )
              ],
            ),
          )
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
  void onPostsCountChanged(int posts) {
    // TODO: implement onPostsCountChanged
  }

  @override
  void onServiceUpdated(Service service) {
    setState(() {
      this.service = service;
    });
  }
}
