import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/tab_listener.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/screens/registration/reset_password_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

import '../../main_screen/main_screen.dart';

class SigninLayout extends StatefulWidget {
  final TabListener tabListener;

  SigninLayout(this.tabListener);

  @override
  _SigninLayoutState createState() => _SigninLayoutState();
}

class _SigninLayoutState extends State<SigninLayout>
    implements UserDataChangeListener {
  var _valueCheck = false;
  String _username = "", _password = "";

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        userSignedIn = false;
      } else {
        checkMySelf(user.uid, this);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomInputField(
            hint: "Username",
            isPasswordField: false,
            keyboardType: TextInputType.name,
            onChange: (value) {
              _username = value.toString();
            },
          ),
          CustomInputField(
            hint: "Password",
            isPasswordField: true,
            keyboardType: TextInputType.visiblePassword,
            onChange: (value) {
              _password = value.toString();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  value: _valueCheck,
                  checkColor: Colors.white,
                  activeColor: Colors.redAccent,
                  onChanged: (newValue) {
                    setState(() {
                      _valueCheck = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    "Remember Me",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_username.isEmpty || _password.isEmpty) {
                  showSnackBar("Both fields required", context);
                  return;
                }

                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _username, password: _password)
                    .then((value) {
                  openScreen(context, MainScreen());
                }).catchError((error) {
                  showSnackBar(error.toString(), context);
                });
              },
              style: redButtonStyle,
              child: Text("Sign In"),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
              ),
              GestureDetector(
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  widget.tabListener.onTabChanged(1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dataReceived(RegisteredUser? registeredUser) {
    mUser = registeredUser;
  }
}
