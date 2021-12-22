import 'package:firebase_auth_practice/models/slot.dart';
import 'package:flutter/material.dart';
class LayoutAppointmentsTable extends StatefulWidget {

  @override
  _LayoutAppointmentsTableState createState() => _LayoutAppointmentsTableState();

  double amount;
  List<Slot> slots;
  String service_id, barber_id;

  LayoutAppointmentsTable({
    required this.amount,
    required this.slots,
    required this.service_id,
    required this.barber_id,
  });
}

class _LayoutAppointmentsTableState extends State<LayoutAppointmentsTable> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
