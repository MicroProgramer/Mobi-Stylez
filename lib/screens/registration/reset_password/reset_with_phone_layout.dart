import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/screens/registration/code_sent_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class ResetPassWithPhone extends StatefulWidget {
  const ResetPassWithPhone({Key? key}) : super(key: key);

  @override
  _ResetPassWithPhoneState createState() => _ResetPassWithPhoneState();
}

class _ResetPassWithPhoneState extends State<ResetPassWithPhone> {
  String _reset_phone = "";

  String _country_code = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Reset Password via Phone",
              style: normal_h1Style_bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                "Please enter your phone number to receive OTP for new password",
                style: normal_h3Style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomInputField(
              hint: "Phone",
              isPasswordField: false,
              onChange: (value) {
                _reset_phone = value.toString();
              },
              keyboardType: TextInputType.phone,
              prefix: CountryCodePicker(
                onChanged: (value) {
                  _country_code = value.toString();
                },
                showFlag: true,
                showFlagMain: true,
                flagWidth: 15,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'PK',
                favorite: ['+92', 'PK'],

                // optional. Shows only country name and flag
                // showCountryOnly: true,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_country_code.isEmpty ||
                  !isPhoneValid(_reset_phone, context, _country_code)) {
                showSnackBar("Please enter a valid phone", context);
                return;
              }
              openScreen(
                  context,
                  CodeSentScreen(
                      userObject: RegisteredUser(
                          user_id: "user_id",
                          firstName: "name",
                          lastName: "name",
                          email: "",
                          phone: _reset_phone,
                          password: "",
                          image_url: "",
                          country_code: _country_code,
                          notification_token: "",
                          lastSeen: 0),
                      resetPassword: true));
            },
            child: Text("Next"),
            style: redButtonStyle,
          ),
        ],
      ),
    );
  }
}
