import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/item_layouts/item_profile_service.dart';
import 'package:firebase_auth_practice/models/service.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class StylistProfileServicesLayout extends StatefulWidget {
  String? slot_id;
  String barber_id;

  @override
  _StylistProfileServicesLayoutState createState() =>
      _StylistProfileServicesLayoutState();

  StylistProfileServicesLayout({
    this.slot_id,
    required this.barber_id,
  });
}

class _StylistProfileServicesLayoutState
    extends State<StylistProfileServicesLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("services")
            .where("barberID", isEqualTo: widget.barber_id)
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

          List<Service> services = [];
          for (var doc in snapshot.data!.docs) {
            Service service =
                Service.fromMap(doc.data() as Map<String, dynamic>);
            services.add(service);
          }

          return services.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return ItemProfileService(
                      service: services[index],
                      slot_id: widget.slot_id,
                      barber_id: widget.barber_id,
                    );
                  },
                )
              : NotFound(
                  message: "No Services found",
                  color: Colors.red,
                );
        });
  }
}
