import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/payment_method.dart';
import 'package:firebase_auth_practice/screens/appointments/payment_completed_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddCardLayout extends StatefulWidget {
  Appointment appointment;

  @override
  _AddCardLayoutState createState() => _AddCardLayoutState();

  AddCardLayout({
    required this.appointment,
  });
}

class _AddCardLayoutState extends State<AddCardLayout> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController card_number_controller = TextEditingController();
  TextEditingController expiry_date_controller = TextEditingController();
  TextEditingController cvv_controller = TextEditingController();

  late String myID;

  late String card_type = "debit_card";
  bool showLoading = false;

  @override
  void initState() {
    myID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: SingleChildScrollView(
        child: Column(
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
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Enter Details",
                  style: TextStyle(color: Color(0xf0710000)),
                  textAlign: TextAlign.center,
                )),
                Expanded(
                    child: Text(
                  "Scan a card",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(label: Text("Name")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: card_number_controller,
                keyboardType: TextInputType.number,
                maxLength: 16,
                decoration: InputDecoration(
                  label: Text("Card Number"),
                  suffixIcon: Container(
                      height: 15,
                      child: Image.asset('assets/${card_type}_logo.png')),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // new CustomInputFormatter(spaceAfter: 4)
                ],
                onChanged: (value) {
                  if (value.startsWith('4')) {
                    setState(() {
                      card_type = "visa";
                    });
                  } else if (value.startsWith('5')) {
                    setState(() {
                      card_type = "mastercard";
                    });
                  } else {
                    setState(() {
                      card_type = "debit_card";
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: expiry_date_controller,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(label: Text("Expiry Date")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: cvv_controller,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(label: Text("CVV")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Text(
                  "Save this card",
                  style: grey_h3Style,
                ),
                onTap: () {
                  String id = "${DateTime.now().millisecondsSinceEpoch}";
                  PaymentMethod paymentMethod = PaymentMethod(
                      card_id: id,
                      user_id: myID,
                      card_holder: name_controller.text,
                      exp_date: expiry_date_controller.text,
                      cvv: cvv_controller.text,
                      card_type: card_type,
                      card_number: '');

                  setState(() {
                    showLoading = true;
                  });
                  usersRef
                      .doc(myID)
                      .collection("payment_methods")
                      .doc(id)
                      .set(paymentMethod.toMap())
                      .then((value) {
                    setState(() {
                      showLoading = false;
                    });
                    Navigator.pop(context);
                    showSnackBar("Card saved successfully", context);
                  }).catchError((error) {
                    setState(() {
                      showLoading = false;
                      showSnackBar(error.toString(), context);
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                  color: Colors.red,
                  child: Text(
                    "Pay Now",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    String id = "${DateTime.now().millisecondsSinceEpoch}";
                    PaymentMethod paymentMethod = PaymentMethod(
                        card_id: id,
                        user_id: myID,
                        card_holder: name_controller.text,
                        exp_date: expiry_date_controller.text,
                        cvv: cvv_controller.text,
                        card_type: card_type,
                        card_number: card_number_controller.text);

                    setState(() {
                      showLoading = true;
                    });
                    usersRef
                        .doc(myID)
                        .collection("payment_methods")
                        .doc(id)
                        .set(paymentMethod.toMap())
                        .then((value) {
                      String id = "${Timestamp.now().millisecondsSinceEpoch}";
                      widget.appointment.id = id;
                      widget.appointment.paid_card_id = paymentMethod.card_id;
                      setState(() {
                        showLoading = true;
                      });
                      appointmentsRef
                          .doc(id)
                          .set(widget.appointment.toMap())
                          .then((value) {
                        setState(() {
                          showLoading = false;
                        });
                        closeAllScreens(context);
                        openScreen(
                            context,
                            PaymentCompletedScreen(
                                appointment: widget.appointment));
                      }).catchError((error) {
                        showSnackBar(error.toString(), context);
                        setState(() {
                          showLoading = false;
                        });
                      });
                    }).catchError((error) {
                      setState(() {
                        showLoading = false;
                        showSnackBar(error.toString(), context);
                      });
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
