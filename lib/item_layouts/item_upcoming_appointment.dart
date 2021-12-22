import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/widgets/maps_with_destination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemUpcomingAppointment extends StatefulWidget {
  Appointment appointment;

  @override
  _ItemUpcomingAppointmentState createState() =>
      _ItemUpcomingAppointmentState();

  ItemUpcomingAppointment({
    required this.appointment,
  });
}

class _ItemUpcomingAppointmentState extends State<ItemUpcomingAppointment>
    implements BarberInfoListener {
  ScrollController controller = ScrollController();
  late Barber barber;

  @override
  void initState() {
    barber = Barber(
        barber_id: widget.appointment.barber_id,
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
    checkForBarberInfo(widget.appointment.barber_id, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 0.5)
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.red,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${timeStampToDateTime(widget.appointment.timestamp, "dd MMM")}'s Appointment",
            style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Appointment with ${barber.firstName} ${barber.lastName}",
            style: white_heading3_style,
          ),
          ListTile(
            title: Text(
              timeStampToDateTime(widget.appointment.timestamp, "MMMM dd"),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text(
              timeStampToDateTime(widget.appointment.timestamp, "hh:mm a"),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.access_time_filled,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text(
              widget.appointment.address,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.add_location_rounded,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text(
              widget.appointment.contact,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.phone_enabled_rounded,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              openScreen(
                  context,
                  MapsWithDestination(
                      origin: LatLng(widget.appointment.drop_lat, widget.appointment.drop_lng),
                      destination: LatLng(barber.latitude, barber.longitude),
                      showMyLocationButton: true,
                      polylineColor: Colors.red,
                      setMyLocationAsOrigin: false,
                      showCustomLocationButton: false,
                      origin_title: "My Location",
                      destination_title: barber.firstName + " " + barber.lastName));
            },
            child: Text("Track Now"),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: BorderSide(
                width: 2,
                color: Colors.white,
              ),
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
}
