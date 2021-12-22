import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/directions_repository.dart';
import 'package:firebase_auth_practice/models/directions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LayoutLocation extends StatefulWidget {
  @override
  _LayoutLocationState createState() => _LayoutLocationState();
}

class _LayoutLocationState extends State<LayoutLocation> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(31.42169763505443, 74.28107886030823),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker _origin = Marker(markerId: MarkerId("unknown0")),
      _destination = Marker(markerId: MarkerId("unknown1"));
  late LatLng _current_position;
  late Marker _my_location_marker =
      Marker(markerId: MarkerId("myLocation"), position: LatLng(0, 0));
  int i = 0;
  bool buttonVisibility = false;
  late Directions? _info = null;
  late LatLng dest;

  @override
  void initState() {
    Location().onLocationChanged.listen((event) {
      double? latitude = event.latitude;
      double? longitude = event.longitude;

      _current_position = LatLng(latitude ?? 0, longitude ?? 0);

      setState(() {
        _origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "My Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(latitude ?? 0, longitude ?? 0),
        );
      });

      if (latitude != null && longitude != null) {
        if (i == 0) {
          _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18),
          ));
        }

        updateMySelf(_current_position);
        updateDestinationMarker(dest);

        i++;
      }
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

  // @override
  // void dispose() {
  //   _googleMapController.dispose();
  //   super.dispose();
  // }

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
            onLongPress: (latlng) {
              dest = latlng;
              updateDestinationMarker(latlng);
            },
            markers: {
              if (_origin.markerId == MarkerId("origin")) _origin,
              if (_destination.markerId == MarkerId("dest")) _destination,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: PolylineId("overview_polyline"),
                  color: Colors.black,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                  geodesic: false,
                  jointType: JointType.mitered,
                )
            },
          ),
          Positioned(
            top: 100,
            left: 10,
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

  Future<void> updateDestinationMarker(LatLng latlng) async {
    setState(() {
      _destination = Marker(
        markerId: MarkerId("dest"),
        infoWindow: InfoWindow(title: "Destination"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: latlng,
      );
    });

    final directions = await DirectionsRepository().getDirections(
        origin: _origin.position,
        destination: _destination.position,
        context: context);
    setState(() {
      _info = directions!;

      if (_info != null) {
        CameraUpdate.newLatLngBounds(_info!.bounds, 100.0);

        showSnackBar(
            "${_info!.totalDistance}, ${_info!.totalDuration}", context);
      }
    });
  }

  void updateMySelf(LatLng myLocation) {
    // mUser!.latitude = myLocation.latitude;
    // mUser!.longitude = myLocation.longitude;

    usersRef.doc(FirebaseAuth.instance.currentUser!.uid).set(mUser!.toMap());
  }
}
