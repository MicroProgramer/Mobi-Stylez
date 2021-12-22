import 'package:firebase_auth_practice/models/selected_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';

class LayoutPickLocation extends StatefulWidget {
  @override
  _LayoutPickLocationState createState() => _LayoutPickLocationState();
}

class _LayoutPickLocationState extends State<LayoutPickLocation> {
  MapPickerController mapPickerController = MapPickerController();
  GoogleMapController? _controller;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );
  var textController = TextEditingController();
  Location location = Location();
  bool initialLocation = true;

  String locationName = "";

  @override
  void initState() {
    location.onLocationChanged.listen((event) {
      double? lat = event.latitude;
      double? lng = event.longitude;

      if (lat != null && lng != null) {
        if (initialLocation) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 18),
          ));
          initialLocation = false;
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick your location"),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: SvgPicture.asset(
              "assets/picker.svg",
              height: 60,
            ),
            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              // hide location button
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
                textController.text = "checking ...";
              },
              onCameraMove: (cameraPosition) async {
                this.cameraPosition = cameraPosition;

                // final coordinates = new Coordinates(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude);
                var address = await GeoCode().reverseGeocoding(
                    latitude: cameraPosition.target.latitude,
                    longitude: cameraPosition.target.longitude);
                print(
                    "locationName: ${address.streetAddress} : ${address.city}");
                locationName =
                    "${address.streetAddress ?? ""}, ${address.city ?? ""}";
                setState(() {
                  textController.text = locationName;
                });
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  fillColor: Colors.yellow,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none),
              controller: textController,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                    // height: 19/19,
                  ),
                ),
                onPressed: () {
                  print(
                      "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                  print("Address: ${textController.text}");

                  Navigator.pop(
                      context,
                      SelectedLocation(
                          name: locationName,
                          latitude: cameraPosition.target.latitude,
                          longitude: cameraPosition.target.longitude));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
