import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/screens/main_screen/main_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:firebase_auth_practice/widgets/header_container_design.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  String _new_password = "";
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoader,
      child: HeaderContainerDesign(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Password",
                  style: normal_h1Style_bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please enter your email to receive a link to  create a new password via email",
                  style: normal_h2Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomInputField(
                    hint: "New Password",
                    isPasswordField: true,
                    onChange: (value) {
                      _new_password = value.toString();
                    },
                    keyboardType: TextInputType.visiblePassword),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomInputField(
                    hint: "Confirm New Password",
                    isPasswordField: true,
                    onChange: (value) {},
                    keyboardType: TextInputType.visiblePassword),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showLoader = true;
                  });
                  await updateUserPassword();
                  setState(() {
                    showLoader = false;
                  });
                },
                child: Text("Next"),
                style: redButtonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserPassword() async {
    await FirebaseAuth.instance.currentUser!
        .updatePassword(_new_password)
        .then((value) {
      showSnackBar("Password Updated", context);
      closeAllScreens(context);
      openScreen(context, MainScreen());
    }).catchError((error) {
      showSnackBar(error.toString(), context);
    });
  }
}
