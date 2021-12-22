import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/service_listener.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemConfirmedAppointment extends StatefulWidget {
  Appointment appointment;

  @override
  _ItemConfirmedAppointmentState createState() =>
      _ItemConfirmedAppointmentState();

  ItemConfirmedAppointment({
    required this.appointment,
  });
}

Widget unpaid = Container(
  padding: EdgeInsets.all(5),
  child: Image.asset("assets/unpaid.png"),
);
Widget paid = Container(
    padding: EdgeInsets.all(5), child: Image.asset("assets/paid.png"));

class _ItemConfirmedAppointmentState extends State<ItemConfirmedAppointment>
    implements BarberInfoListener, ServiceListener {
  late Service service;
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

  @override
  void initState() {
    service = Service(
        service_id: widget.appointment.service_id,
        title: "service",
        description: "description",
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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 2,
              offset: Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(test_image),
                      radius: 20,
                    ),
                    Text(
                      barber.firstName + " " + barber.lastName,
                      style: normal_h4Style_bold,
                    )
                  ],
                ),
              ),
              Expanded(child: widget.appointment.paid ? paid : unpaid),
            ],
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                test_image,
                height: 50.0,
                width: 50.0,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: normal_h4Style,
                    overflow: TextOverflow.ellipsis,
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Text(
                    "\$${widget.appointment.paid_amount}",
                    style: normal_h4Style_bold,
                    textAlign: TextAlign.end,
                  ),
                  flex: 2,
                ),
              ],
            ),
            subtitle: Text(
              service.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: normal_h5Style,
            ),
            trailing: Text(
              timeStampToDateTime(
                      widget.appointment.timestamp, "EEE, dd MMM ") +
                  "\n" +
                  timeStampToDateTime(widget.appointment.timestamp, "hh:mm a"),
              textAlign: TextAlign.center,
            ),
          ),
          Card(
            elevation: 5,
            child: ListTile(
              minVerticalPadding: 0,
              minLeadingWidth: 30,
              leading: Image.asset(
                "assets/red_marker.png",
                alignment: Alignment.center,
                height: 30,
                width: 30,
              ),
              title: Text(
                "Appointment Location",
                style: normal_h5Style_bold,
              ),
              subtitle: Text(
                widget.appointment.address,
                style: normal_h6Style,
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

  @override
  void onServiceUpdated(Service service) {
    setState(() {
      this.service = service;
    });
  }
}
