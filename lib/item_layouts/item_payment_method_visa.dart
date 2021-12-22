import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/payment_method.dart';
import 'package:firebase_auth_practice/screens/appointments/payment_completed_screen.dart';
import 'package:flutter/material.dart';

class ItemPaymentMethodVisa extends StatefulWidget {
  @override
  _ItemPaymentMethodVisaState createState() => _ItemPaymentMethodVisaState();

  PaymentMethod paymentMethod;
  Appointment appointment;

  ItemPaymentMethodVisa({
    required this.paymentMethod,
    required this.appointment,
  });
}

class _ItemPaymentMethodVisaState extends State<ItemPaymentMethodVisa> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          "assets/item_visa.png",
          // height: 100.0,
          // width: 100.0,
        ),
      ),
      onTap: () {
        String id = "${Timestamp.now().millisecondsSinceEpoch}";
        widget.appointment.id = id;
        widget.appointment.paid_card_id = widget.paymentMethod.card_id;
        appointmentsRef.doc(id).set(widget.appointment.toMap()).then((value) {
          closeAllScreens(context);
          openScreen(
              context, PaymentCompletedScreen(appointment: widget.appointment));


        }).catchError((error) {
          showSnackBar(error.toString(), context);
        });
      },
    );
  }
}
