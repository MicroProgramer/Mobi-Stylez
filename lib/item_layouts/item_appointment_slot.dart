import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_appointments_screen.dart';
import 'package:flutter/material.dart';

class ItemEventSlot extends StatefulWidget {
  DateTime dateTime;
  bool isAvailable;
  String slot_id, service_id, barber_id;
  double amount;

  @override
  _ItemEventSlotState createState() => _ItemEventSlotState();

  ItemEventSlot({
    required this.dateTime,
    required this.isAvailable,
    required this.slot_id,
    required this.service_id,
    required this.barber_id,
    required this.amount,
  });
}

class _ItemEventSlotState extends State<ItemEventSlot> {
  TextStyle availableStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  TextStyle unavailableStyle = TextStyle(color: Colors.grey, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () {
            if (!widget.isAvailable) {
              showSnackBar("Slot not available", context);
            } else {
              Slot slot = Slot(
                  slot_id: widget.slot_id,
                  barber_id: widget.barber_id,
                  user_id: FirebaseAuth.instance.currentUser!.uid,
                  service_id: widget.service_id,
                  timestamp: widget.dateTime.millisecondsSinceEpoch,
                  available: false);
              showModalBottomSheetMenu(
                  context: context,
                  content: StylistProfileAppointmentsScreen(
                    slot: slot,
                    barber_id: widget.barber_id,
                    amount: widget.amount,
                  ));
            }
          },
          overlayColor: MaterialStateProperty.all(Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${timeStampToDateTime(widget.dateTime.millisecondsSinceEpoch, "hh:mm a")}",
              style: (widget.isAvailable ? availableStyle : unavailableStyle),
            ),
          ),
        ),
      ),
    );
  }
}
