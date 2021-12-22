import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/interfaces/available_slots_listener.dart';
import 'package:firebase_auth_practice/item_layouts/item_slot.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailableSlotScreen extends StatefulWidget {
  @override
  _AvailableSlotScreenState createState() => _AvailableSlotScreenState();

  String barber_id;

  AvailableSlotScreen({
    required this.barber_id,
  });
}

class _AvailableSlotScreenState extends State<AvailableSlotScreen> implements AvailableSlotsListener {
  var controller;
  Map<String, List<Slot>> slotsMap = Map();

  @override
  void initState() {
    // TODO: implement initState
    getAvailableSlots(widget.barber_id, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Slots"),
      ),
      body: /*StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("slots")
              .where('barber_id', isEqualTo: widget.barber_id)
              .snapshots(),
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

            List<Slot> slotsData = [];
            for (var doc in snapshot.data!.docs) {
              Slot slot = Slot.fromMap(doc.data() as Map<String, dynamic>);
              slotsData.add(slot);
            }
            print("total slots: ${slotsData.length}");

            Map<String, List<Slot>> slotsMap = filterSlotsToMap(slotsData);

            return*/ /*slotsData.length > 0
                ?*/ ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: slotsMap.length,
                    controller: controller,
                    itemBuilder: (context, index) {
                      return Container(
                        child: ItemSlot(
                          slotsMap: slotsMap.entries.toList()[index],
                        ),
                      );
                    },
                  ),);
  //               : Center(
  //                   child: NotFound(
  //                     message: "No slots available",
  //                     color: Colors.red,
  //                   ),
  //                 );
  //         }
  //
  // // ),
  //
  //     /*ListView.builder(
  //       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  //       itemCount: 6,
  //       controller: controller,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           child: ItemSlot(),
  //         );
  //       },
  //     ),*/
  //   // );
  }

  Map<String, List<Slot>> filterSlotsToMap(List<Slot> slotsData) {
    Map<String, List<Slot>> finalMap = Map();

    for (Slot slot in slotsData) {
      int timestamp = slot.timestamp;
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String x = DateFormat("EEE dd, MMM").format(date);

      if (!finalMap.containsKey(x)) {
        finalMap.addAll({x: []});
      }
      finalMap.update(x, (value) {
        value.add(slot);
        return value;
      });
    }

    return finalMap;
  }

  @override
  void updatedSlots(Map<DateTime, List<Slot>> receivedMap) {
    slotsMap = Map();
    for (MapEntry<DateTime, List<Slot>> mapEntry in receivedMap.entries){
      DateTime x = mapEntry.key;
      MapEntry<String, List<Slot>> entry = MapEntry(DateFormat("EEE dd, MMM").format(x), mapEntry.value);

      setState(() {
        slotsMap.addAll({entry.key: entry.value});
      });
    }
  }
}
