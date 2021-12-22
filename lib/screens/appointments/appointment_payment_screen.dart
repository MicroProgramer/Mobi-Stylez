import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/item_layouts/item_payment_method_mastercard.dart';
import 'package:firebase_auth_practice/item_layouts/item_payment_method_visa.dart';
import 'package:firebase_auth_practice/models/appointment.dart';
import 'package:firebase_auth_practice/models/payment_method.dart';
import 'package:firebase_auth_practice/screens/appointments/add_card_layout.dart';
import 'package:firebase_auth_practice/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AppointmentPaymentScreen extends StatefulWidget {
  Appointment appointment;

  @override
  _AppointmentPaymentScreenState createState() =>
      _AppointmentPaymentScreenState();

  AppointmentPaymentScreen({
    required this.appointment,
  });
}

class _AppointmentPaymentScreenState extends State<AppointmentPaymentScreen> {
  var controller;

  late String myID;
  bool showProgress = false;

  @override
  void initState() {
    setState(() {
      myID = FirebaseAuth.instance.currentUser!.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Methods"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Payment details",
                  style: grey_h1Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Saved Cards",
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheetMenu(
                              context: context,
                              content: AddCardLayout(
                                appointment: widget.appointment,
                              ));
                        },
                        child: Text(
                          "⚫ Add New",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xf0710000)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize(context).height * 0.4,
                child: StreamBuilder<QuerySnapshot>(
                    stream: usersRef
                        .doc(myID)
                        .collection("payment_methods")
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

                      List<PaymentMethod> paymentMethods = [];
                      for (var doc in snapshot.data!.docs) {
                        paymentMethods.add(PaymentMethod.fromMap(
                            doc.data() as Map<String, dynamic>));
                      }

                      return ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: paymentMethods.length,
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          PaymentMethod paymentMethod = paymentMethods[index];
                          bool mastercard =
                              (paymentMethod.card_type == "mastercard");
                          return GestureDetector(
                            child: mastercard
                                ? ItemPaymentMethodMastercard(
                                    appointment: widget.appointment,
                                    paymentMethod: paymentMethod)
                                : ItemPaymentMethodVisa(
                                    appointment: widget.appointment,
                                    paymentMethod: paymentMethod),
                            onTap: () {
                              setState(() {
                                showProgress = true;
                              });
                            },
                          );
                        },
                      );
                    }),
              ),
              CustomButton(
                  color: Colors.red,
                  child: Text(
                    "Pay with card",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheetMenu(
                        context: context,
                        content:
                            AddCardLayout(appointment: widget.appointment));
                  }),
              CustomButton(
                  color: Colors.yellow,
                  child: Image.asset(
                    "assets/paypal_logo.png",
                    height: 100,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
