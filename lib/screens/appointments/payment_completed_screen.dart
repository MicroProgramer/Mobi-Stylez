import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/screens/main_screen/main_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PaymentCompletedScreen extends StatefulWidget {

  Appointment appointment;


  @override
  _PaymentCompletedScreenState createState() => _PaymentCompletedScreenState();

  PaymentCompletedScreen({
    required this.appointment,
  });
}

class _PaymentCompletedScreenState extends State<PaymentCompletedScreen> {

  @override
  void initState() {

    slotsRef.doc(widget.appointment.slot_id).update({"available": false});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Successful"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                child: Image.asset(
                  "assets/payment_complete.png",
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You have successfully paid for availing your service from stylist. The total amount you paid is \$${widget.appointment.paid_amount}.",
                  textAlign: TextAlign.center,
                  style: normal_h2Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: CustomButton(
                    color: Colors.red,
                    child: Text(
                      "Finish",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      closeAllScreens(context);
                      openScreen(context, MainScreen());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
