import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_confirmed_appointment.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class StylistProfileConfirmedAppointmentsLayout extends StatefulWidget {
  String barber_id;


  @override
  _StylistProfileConfirmedAppointmentsLayoutState createState() =>
      _StylistProfileConfirmedAppointmentsLayoutState();

  StylistProfileConfirmedAppointmentsLayout({
    required this.barber_id,
  });
}

class _StylistProfileConfirmedAppointmentsLayoutState extends State<StylistProfileConfirmedAppointmentsLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: appointmentsRef.where('barber_id', isEqualTo: widget.barber_id).snapshots(),
        builder: (context, snapshot){

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

          List<Appointment> appointments = [];
          for (var doc in snapshot.data!.docs){
            appointments.add(Appointment.fromMap(doc.data() as Map<String, dynamic>));
          }

          return appointments.length > 0 ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return ItemConfirmedAppointment(appointment: appointments[index]);
            },
          ) : NotFound(message: "No appointments with this barber yet");
        });
  }
}
