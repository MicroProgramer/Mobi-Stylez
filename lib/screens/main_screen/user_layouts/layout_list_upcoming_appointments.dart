import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_upcoming_appointment.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';

class LayoutListUpcomingAppointments extends StatefulWidget {
  const LayoutListUpcomingAppointments({Key? key}) : super(key: key);

  @override
  _LayoutListUpcomingAppointmentsState createState() =>
      _LayoutListUpcomingAppointmentsState();
}

class _LayoutListUpcomingAppointmentsState
    extends State<LayoutListUpcomingAppointments> {
  var controller = ScrollController();

  String myID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: appointmentsRef
            .where('user_id', isEqualTo: myID)
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

          List<Appointment> appointments = [];
          for (var doc in snapshot.data!.docs) {
            Appointment appointment =
                Appointment.fromMap(doc.data() as Map<String, dynamic>);
            if (appointment.timestamp > DateTime.now().millisecondsSinceEpoch){
              appointments.add(appointment);
            }
          }

          return (appointments.length) > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),

                  itemCount: appointments.length,
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: 1,
                      curve: Curves.easeInOutQuart,
                      child: AnimatedPadding(
                        padding: EdgeInsets.all(4),
                        duration: Duration(milliseconds: 1000),
                        child: ItemUpcomingAppointment(
                            appointment: appointments[index]),
                      ),
                    );
                  },
                )
              : NotFound(message: "No upcoming appointments");
        });
  }
}
