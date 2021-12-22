import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemSlot extends StatefulWidget {
  MapEntry<String, List<Slot>> slotsMap;

  ItemSlot({
    required this.slotsMap,
  });

  @override
  _ItemSlotState createState() => _ItemSlotState();
}

ButtonStyle unSelectedButton = TextButton.styleFrom(
  primary: Colors.black,
  onSurface: Colors.black,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    side: BorderSide(width: 1, color: Colors.grey),
  ),
);

class _ItemSlotState extends State<ItemSlot> {
  late String dateTime;

  @override
  void initState() {
    dateTime = widget.slotsMap.key;
    widget.slotsMap.value.sort((a, b) {
      return a.timestamp.compareTo(b.timestamp);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 8, left: 15),
                    child: Text(
                      dateTime,
                      style: normal_h1Style_bold,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 8, left: 15),
                    child:
                        Text("${widget.slotsMap.value.length} Slots available"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: slotsToWidgets(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> slotsToWidgets() {
    List<Widget> slotsWidgets = [];

    for (Slot slot in widget.slotsMap.value) {
      slotsWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              if (!slot.available || (slot.timestamp < DateTime.now().millisecondsSinceEpoch)) {
                showSnackBar("Slot is not available", context);
              } else {
                openScreen(
                    context,
                    StylistProfileScreen(
                      barber_id: widget.slotsMap.value[0].barber_id,
                      slot_id: slot.slot_id,
                      layout_index: 1,
                    ));
              }
            },
            child: Text(
              DateFormat("hh:mm a")
                  .format(DateTime.fromMillisecondsSinceEpoch(slot.timestamp)),
              style:
                  TextStyle(color: slot.available ? Colors.black : Colors.grey),
            ),
            style: unSelectedButton,
          ),
        ),
      );
    }

    return slotsWidgets;
  }
}
