import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/directions_repository.dart';
import 'package:firebase_auth_practice/models/directions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsWithDestination extends StatefulWidget {
  LatLng origin;
  LatLng destination;
  bool showMyLocationButton;
  bool setMyLocationAsOrigin;
  String origin_title;
  String destination_title;
  Color polylineColor;
  bool showCustomLocationButton;

  @override
  _MapsWithDestinationState createState() => _MapsWithDestinationState();

  MapsWithDestination({
    required this.origin,
    required this.destination,
    required this.showMyLocationButton,
    required this.setMyLocationAsOrigin,
    required this.origin_title,
    required this.destination_title,
    required this.polylineColor,
    required this.showCustomLocationButton,
  });
}

class _MapsWithDestinationState extends State<MapsWithDestination> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(31.42169763505443, 74.28107886030823),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker _origin = Marker(markerId: MarkerId("origin")),
      _destination = Marker(markerId: MarkerId("dest"));
  late LatLng _current_position;
  int i = 0;
  bool buttonVisibility = false;
  late Directions? _info = null;
  late LatLng dest;

  String distanceAndTime = "Tracking Barber...";

  @override
  void initState() {

    if (widget.setMyLocationAsOrigin) {
      Location().onLocationChanged.listen((event) {
        double? latitude = event.latitude;
        double? longitude = event.longitude;

        _current_position = LatLng(latitude ?? 0, longitude ?? 0);

        setState(() {
          _origin = Marker(
            markerId: MarkerId("origin"),
            infoWindow: InfoWindow(title: widget.origin_title),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(latitude ?? 0, longitude ?? 0),
          );
        });

        if (latitude != null && longitude != null) {
          if (i == 0) {
            _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(latitude, longitude), zoom: 18),
            ));
          }

          // updateMySelf(_current_position);
          // updateDestinationMarker(dest);

          i++;
        }
      });
    } else {
      setState(() {
        _origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: widget.origin_title),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: widget.origin,
        );
      });
    }

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
      appBar: AppBar(
        title: Text(distanceAndTime),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(

              myLocationButtonEnabled: widget.showMyLocationButton,
              initialCameraPosition: _initialCameraPosition,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) {
                _googleMapController = controller;
                updateDestinationMarker(widget.destination);
              },
              markers: {
                _origin,
                _destination,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: PolylineId("overview_polyline"),
                    color: widget.polylineColor,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                    geodesic: false,
                    jointType: JointType.mitered,
                  )
              },
            ),
            Visibility(
              visible: widget.showCustomLocationButton,
              child: Positioned(
                bottom: 20,
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateDestinationMarker(LatLng latlng) async {
    setState(() {
      _destination = Marker(
        markerId: MarkerId("dest"),
        infoWindow: InfoWindow(title: widget.destination_title),
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

        setState(() {
          distanceAndTime = "${_info!.totalDistance}, ${_info!.totalDuration}";
        });
      }
    });
  }
}
