import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class ResetPassWithEmail extends StatefulWidget {
  const ResetPassWithEmail({Key? key}) : super(key: key);

  @override
  _ResetPassWithEmailState createState() => _ResetPassWithEmailState();
}

class _ResetPassWithEmailState extends State<ResetPassWithEmail> {
  String _reset_email = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Reset Password via Email",
              style: normal_h1Style_bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                "Please enter your email to receive a link to create a new password",
                style: normal_h3Style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomInputField(
                hint: "Email",
                isPasswordField: false,
                onChange: (value) {
                  _reset_email = value.toString();
                },
                keyboardType: TextInputType.emailAddress),
          ),
          ElevatedButton(
            onPressed: () {
              if (_reset_email.isEmpty || !isEmailValid(_reset_email)) {
                showSnackBar("Please enter a valid email", context);
                return;
              }
              FirebaseAuth.instance
                  .sendPasswordResetEmail(email: _reset_email)
                  .then((value) {
                showSnackBar("Password reset link sent to your email", context);
                Navigator.pop(context);
              });
            },
            child: Text("Next"),
            style: redButtonStyle,
          ),
        ],
      ),
    );
  }
}
