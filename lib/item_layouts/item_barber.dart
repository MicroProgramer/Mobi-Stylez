import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:flutter/material.dart';

class ItemBarber extends StatefulWidget {
  Barber barber;

  @override
  _ItemBarberState createState() => _ItemBarberState();

  ItemBarber({
    required this.barber,
  });
}

class _ItemBarberState extends State<ItemBarber> {

  int distance = 0;
  double kmDistance = 0;

  @override
  void initState() {
    distance = calculateDistance(myLocationPoints!.latitude, myLocationPoints!.longitude, widget.barber.latitude, widget.barber.longitude);
    kmDistance = distance/1000;
    kmDistance = roundDouble(kmDistance, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        openScreen(
            context, StylistProfileScreen(barber_id: widget.barber.barber_id));
      },
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(widget.barber.image_url),
      ),
      title: Text(
        widget.barber.firstName + " " + widget.barber.lastName,
        style: normal_h2Style_bold,
      ),
      trailing: Visibility(
        visible: !(myLocationPoints == null || myLocationPoints!.latitude == 0 ||
            myLocationPoints!.longitude == 0),
        child: SizedBox(
          width: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 18,),
              Text(
                  " ${distance < 1000 ? distance : "${kmDistance}k" }m",
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
