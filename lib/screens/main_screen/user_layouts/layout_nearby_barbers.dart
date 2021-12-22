import 'dart:developer';

import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/interfaces/barbers_change_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LayoutNearbyBarbers extends StatefulWidget {
  double metersLimit;

  @override
  _LayoutNearbyBarbersState createState() => _LayoutNearbyBarbersState();

  LayoutNearbyBarbers({
    required this.metersLimit,
  });
}

class _LayoutNearbyBarbersState extends State<LayoutNearbyBarbers>
    implements BarbersChangeListener {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(31.42169763505443, 74.28107886030823),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();
  late LatLng _current_position;
  List<Barber> barbersList = [];
  Marker _origin = Marker(markerId: MarkerId("origin"));

  @override
  void initState() {
    fetchAllBarbers(this);

    Location().onLocationChanged.listen((event) {
      double? latitude = event.latitude;
      double? longitude = event.longitude;

      _current_position = LatLng(latitude ?? 0, longitude ?? 0);
      myLocationPoints = _current_position;
      setState(() {
        _origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "My Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(latitude ?? 0, longitude ?? 0),
        );
      });
      updateMarkers();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_googleMapController != null) {
      _googleMapController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (controller) {
              _googleMapController = controller;
            },
            markers: this
                .markers /*{
              if (_origin.markerId == MarkerId("origin")) _origin,
              if (_destination.markerId == MarkerId("dest")) _destination,
            }*/
            ,
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey, spreadRadius: 2)
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: IconButton(
                    onPressed: () {
                      if (_googleMapController != null) {
                        _googleMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(_current_position.latitude,
                                    _current_position.longitude),
                                zoom: 18),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.my_location)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onBarbersChanged(List<Barber> barbers) {
    barbersList = barbers;
    updateMarkers();
  }

  Future<void> updateMarkers() async {
    Set<Marker> tempMarkers = Set();
    tempMarkers.add(_origin);
    for (Barber barber in barbersList) {
      double distance = calculateDistance(_origin.position.latitude,
          _origin.position.longitude, barber.latitude, barber.longitude).toDouble();
      print("distance: $distance of ${barber.firstName}");

      if (distance <= widget.metersLimit) {
        tempMarkers.add(Marker(
            markerId: MarkerId("${barber.barber_id}"),
            infoWindow: InfoWindow(
                title: "${barber.firstName + " " + barber.lastName}"),
            icon:
                await getMarkerImageFromUrl(barber.image_url, targetWidth: 50),
            position: LatLng(barber.latitude, barber.longitude),
            onTap: () {
              openScreen(
                  context, StylistProfileScreen(barber_id: barber.barber_id));
            }));

        setState(() {
          markers = tempMarkers;
        });
      }
    }

    log("tempMarkers: $tempMarkers");
  }
}
