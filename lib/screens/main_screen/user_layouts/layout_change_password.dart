import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../main_screen.dart';

class LayoutChangePassword extends StatefulWidget {
  const LayoutChangePassword({Key? key}) : super(key: key);

  @override
  _LayoutChangePasswordState createState() => _LayoutChangePasswordState();
}

class _LayoutChangePasswordState extends State<LayoutChangePassword> {
  String _new_password = "";
  String _old_password = "";
  bool showLoader = false;

  String _confirm_new_password = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoader,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Change Password",
                style: normal_h1Style_bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomInputField(
                  hint: "Old Password",
                  isPasswordField: true,
                  onChange: (value) {
                    _new_password = value.toString();
                  },
                  keyboardType: TextInputType.visiblePassword),
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
                  onChange: (value) {
                    _confirm_new_password = value.toString();
                  },
                  keyboardType: TextInputType.visiblePassword),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_old_password.isEmpty ||
                    _new_password.isEmpty ||
                    _confirm_new_password.isEmpty) {
                  showSnackBar("All fields required", context);
                  return;
                } else if (_new_password != _confirm_new_password) {
                  showSnackBar(
                      "New password does not match with confirm password",
                      context);
                  return;
                }
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
    );
  }

  Future<void> updateUserPassword() async {
    var credentials = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email.toString(),
        password: _old_password);

    FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credentials)
        .then((value) async => {
              await FirebaseAuth.instance.currentUser!
                  .updatePassword(_new_password)
                  .then((value) async {
                await updateInDatabase();
                closeAllScreens(context);
                openScreen(context, MainScreen());
              }).catchError((error) {
                setState(() {
                  showLoader = false;
                });
                showSnackBar(error.toString(), context);
              })
            });
  }

  updateInDatabase() {
    usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"password": _new_password})
        .then((value) => {
              setState(() {
                showLoader = false;
                showSnackBar("Password Updated", context);
              })
            })
        .catchError((error) {
          setState(() {
            showLoader = false;
            showSnackBar(error.toString(), context);
          });
        });
  }
}
