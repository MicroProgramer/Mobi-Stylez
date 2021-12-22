import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/screens/appointments/appointment_payment_screen.dart';
import 'package:flutter/material.dart';

class AskPayNowScreen extends StatefulWidget {
  Appointment appointment;

  @override
  _AskPayNowScreenState createState() => _AskPayNowScreenState();

  AskPayNowScreen({
    required this.appointment,
  });
}

class _AskPayNowScreenState extends State<AskPayNowScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 25),
            child: Image.asset(
              "assets/wallet_group.png",
              height: screenSize(context).height * 0.4,
              width: screenSize(context).width * 0.6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Thank you!",
              style: heading1_style,
            ),
          ),
          Text(
            "for your request",
            style: heading3_style,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 18.0, bottom: 8, left: 5, right: 5),
            child: Text(
              "Your Request is now being processed. We will let you know once the Request has been confirmed. Check the status of your Request after payment.",
              style: normal_h2Style,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                openScreen(
                    context,
                    AppointmentPaymentScreen(
                      appointment: widget.appointment,
                    ));
              },
              child: Text(
                "Pay Now",
                style: normal_h1Style_bold,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shadowColor: Colors.redAccent,
                padding: EdgeInsets.all(10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(1000, 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Pay Later",
                style: normal_h1Style_bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
