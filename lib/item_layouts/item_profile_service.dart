import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/models/service.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_appointments.dart';
import 'package:firebase_auth_practice/screens/stylist_profile_appointments_screen.dart';
import 'package:flutter/material.dart';

class ItemProfileService extends StatefulWidget {
  Service service;
  String? slot_id;
  String barber_id;

  @override
  _ItemProfileServiceState createState() => _ItemProfileServiceState();

  ItemProfileService({
    required this.service,
    this.slot_id,
    required this.barber_id,
  });
}

class _ItemProfileServiceState extends State<ItemProfileService> {
  String myID = "";

  @override
  void initState() {
    myID = FirebaseAuth.instance.currentUser!.uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 2)],
            image: DecorationImage(
                image: NetworkImage(widget.service.image_url), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.service.title,
                overflow: TextOverflow.ellipsis,
                style: normal_h4Style,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "\$${doubleWithoutDecimalToInt(
                    widget.service.minPrice)} - \$${doubleWithoutDecimalToInt(
                    widget.service.maxPrice)}",
                style: normal_h5Style_bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "(${widget.service.description})",
          style: normal_h5Style,
          overflow: TextOverflow.visible,
        ),
        trailing: ElevatedButton(
          onPressed: () {
            if (widget.slot_id != null) {
              Slot slot = Slot(slot_id: widget.slot_id!,
                  barber_id: widget.barber_id,
                  user_id: myID,
                  service_id: widget.service.service_id,
                  timestamp: DateTime
                      .now()
                      .millisecondsSinceEpoch,
                  available: false);
              openScreen(
                  context,
                  StylistProfileAppointmentsScreen(
                    slot: slot,
                    amount: widget.service.minPrice,
                    barber_id: widget.barber_id,
                  ));
            } else {
              showModalBottomSheetMenu(
                context: context,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.8,
                content: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("slots")
                        .where("barber_id", isEqualTo: widget.barber_id)
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

                      List<Slot> slots = [];
                      for (var doc in snapshot.data!.docs) {
                        Slot slot =
                        Slot.fromMap(doc.data() as Map<String, dynamic>);
                        slots.add(slot);
                      }

                      return LayoutAppointments(
                        slots: slots,
                        amount: widget.service.minPrice,
                        service_id: widget.service.service_id,
                        barber_id: widget.barber_id,
                      );
                    }),
              );
            }
          },
          child: Text("Book now"),
          style: redButtonProfileStyle_small,
        ),
      ),
    );
  }
}
