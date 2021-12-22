import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/selected_location.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/appointments/ask_pay_now_screen.dart';
import 'package:firebase_auth_practice/screens/stylist_profile/pick_location_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StylistProfileBookAppointmentLayout extends StatefulWidget {
  Slot slot;

  double amount;

  @override
  _StylistProfileBookAppointmentLayoutState createState() =>
      _StylistProfileBookAppointmentLayoutState();

  StylistProfileBookAppointmentLayout({
    required this.slot,
    required this.amount,
  });
}

class _StylistProfileBookAppointmentLayoutState
    extends State<StylistProfileBookAppointmentLayout> {
  DateTime selectedDate = DateTime.now();

  SelectedLocation? selectedLocation;
  late String myID;
  TextEditingController firstName_controller = TextEditingController();
  TextEditingController lastName_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  TextEditingController country_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();

  @override
  void initState() {
    myID = FirebaseAuth.instance.currentUser!.uid;
    selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.slot.timestamp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hint: "First Name",
                  isPasswordField: false,
                  onChange: (value) {},
                  controller: firstName_controller,
                  keyboardType: TextInputType.name,
                ),
              ),
              Expanded(
                child: CustomInputField(
                  hint: "Last Name",
                  controller: lastName_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.name,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hint: "Email",
                  controller: email_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Expanded(
                child: CustomInputField(
                  hint: "Contact",
                  controller: contact_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hint: "Country",
                  controller: country_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
              Expanded(
                child: CustomInputField(
                  hint: "State",
                  controller: state_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hint: "City",
                  controller: city_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
              Expanded(
                child: CustomInputField(
                  hint: "Address",
                  controller: address_controller,
                  isPasswordField: false,
                  onChange: (value) {},
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Appointment Date",
                    textAlign: TextAlign.center,
                    style: normal_h3Style_bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Appointment Time",
                    textAlign: TextAlign.center,
                    style: normal_h3Style_bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(timeStampToDateTime(
                                widget.slot.timestamp, "dd")),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(timeStampToDateTime(
                                widget.slot.timestamp, "MMM")),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(timeStampToDateTime(
                                widget.slot.timestamp, "yyyy")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(timeStampToDateTime(
                                  widget.slot.timestamp, "hh")),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(timeStampToDateTime(
                                  widget.slot.timestamp, "mm")),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(timeStampToDateTime(
                                  widget.slot.timestamp, "a")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Card(
                  margin: EdgeInsets.only(right: 5, left: 5),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    minVerticalPadding: 0,
                    minLeadingWidth: 30,
                    onTap: () async {
                      selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutPickLocation()));
                    },
                    leading: Image.asset(
                      "assets/red_marker.png",
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                    ),
                    title: Text(
                      "Drop Off your location",
                      style: normal_h5Style_bold,
                    ),
                    subtitle: Text(
                      selectedLocation != null
                          ? (selectedLocation!.name ??
                              "Click here to select location")
                          : "Click here to select location",
                      style: normal_h6Style,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedLocation == null) {
                        showSnackBar(
                            "Please select drop off location", context);
                        return;
                      }
                      String firstName = firstName_controller.text;
                      String lastName = firstName_controller.text;
                      String email = firstName_controller.text;
                      String contact = firstName_controller.text;
                      String country = firstName_controller.text;
                      String state = firstName_controller.text;
                      String city = firstName_controller.text;
                      String address = firstName_controller.text;

                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          email.isEmpty ||
                          contact.isEmpty ||
                          country.isEmpty ||
                          state.isEmpty ||
                          city.isEmpty ||
                          address.isEmpty){
                        showSnackBar("All fields are required", context);
                        return;
                      }
                        showModalBottomSheetMenu(
                            context: context,
                            content: AskPayNowScreen(
                              appointment: Appointment(
                                  id: "",
                                  user_id: myID,
                                  barber_id: widget.slot.barber_id,
                                  name: firstName + " " + lastName,
                                  email: email,
                                  contact: contact,
                                  country: country,
                                  state: state,
                                  city: city,
                                  address: address,
                                  timestamp: widget.slot.timestamp,
                                  drop_lat: selectedLocation!.latitude!,
                                  drop_lng: selectedLocation!.longitude!,
                                  paid: false,
                                  completed: false,
                                  paid_card_id: "",
                                  rating: 0,
                                  paid_amount: widget.amount,
                                  slot_id: widget.slot.slot_id,
                                  service_id: widget.slot.service_id),
                            ));
                    },
                    style: redButtonStyle,
                    child: Text("Send Request"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
