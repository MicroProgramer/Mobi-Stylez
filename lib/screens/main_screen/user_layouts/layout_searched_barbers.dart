import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_barber.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LayoutSearchedBarbers extends StatefulWidget {
  String searchQuery;

  @override
  _LayoutSearchedBarbersState createState() => _LayoutSearchedBarbersState();

  LayoutSearchedBarbers({
    required this.searchQuery,
  });
}

class _LayoutSearchedBarbersState extends State<LayoutSearchedBarbers> {
  @override
  void initState() {
    Location().onLocationChanged.listen((event) {
      setState(() {
        myLocationPoints = LatLng(event.latitude ?? 0, event.longitude ?? 0);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: barbersRef.snapshots(),
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

        List<Barber> barbers = [];
        for (var doc in snapshot.data!.docs) {
          Barber barber = Barber.fromMap(doc.data() as Map<String, dynamic>);
          if (widget.searchQuery.isEmpty ||
              barber.firstName.toLowerCase().contains(widget.searchQuery) ||
              barber.lastName.toLowerCase().contains(widget.searchQuery))
            barbers.add(barber);
        }

        return barbers.length > 0
            ? ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: barbers.length,
                itemBuilder: (context, index) {
                  return ItemBarber(barber: barbers[index]);
                },
              )
            : NotFound(
                message: "No Barbers found for \"${widget.searchQuery}\"");
      },
    );
  }
}
