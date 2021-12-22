import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/update_phone_otp_screen.dart';
import 'package:firebase_auth_practice/screens/registration/authentication_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:firebase_auth_practice/widgets/khali_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LayoutProfileUpdate extends StatefulWidget {
  @override
  _LayoutProfileUpdateState createState() => _LayoutProfileUpdateState();
}

class _LayoutProfileUpdateState extends State<LayoutProfileUpdate>
    implements UserDataChangeListener {
  String _phone = "", _password = "";
  String _country_code = "";
  TextEditingController firstname_controller = TextEditingController();
  TextEditingController lastname_controller = TextEditingController(),
      phone_controller = TextEditingController();
  late ImagePicker _picker;
  XFile? pickedImage;
  XFile? oldPickedImage = null;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool showLoading = true;
  var _auth = FirebaseAuth.instance;
  bool imageChanged = false;

  String _firstname = "";
  String _lastname = "";

  @override
  void initState() {
    _picker = ImagePicker();
    setState(() {
      showLoading = (mUser == null || mUser!.user_id.isEmpty);
    });
    if (showLoading) {
      checkMySelf(_auth.currentUser!.uid, this);
      return;
    }

    setState(() {
      _firstname = firstname_controller.text = mUser!.firstName;
      _lastname = lastname_controller.text = mUser!.lastName;
      _phone = phone_controller.text = mUser!.phone;
      _country_code = mUser!.country_code;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.15),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: oldPickedImage == null
                                ? NetworkImage(mUser!.image_url)
                                : FileImage(File(pickedImage!.path))
                                    as ImageProvider)),
                  ),
                  Positioned(
                    child: Image.asset(
                      'assets/camera.png',
                      height: 30,
                    ),
                    bottom: 0,
                    right: 0,
                  )
                ],
              ),
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Wrap(
                        children: [
                          ListTile(
                            title: Text("Choose an option",
                                textAlign: TextAlign.center,
                                style: normal_h3Style_bold),
                          ),
                          ListTile(
                            leading: Icon(Icons.camera),
                            title: Text('Camera'),
                            onTap: () async {
                              pickedImage = await _picker.pickImage(
                                  source: ImageSource.camera);

                              Navigator.pop(context);
                              if (pickedImage == null) {
                                return;
                              }
                              setState(() {
                                oldPickedImage = pickedImage;
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.monochrome_photos),
                            title: Text('Gallery'),
                            onTap: () async {
                              pickedImage = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              Navigator.pop(context);
                              if (pickedImage == null) {
                                return;
                              }
                              setState(() {
                                oldPickedImage = pickedImage;
                              });
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            CustomInputField(
              hint: "First Name",
              keyboardType: TextInputType.name,
              isPasswordField: false,
              controller: firstname_controller,
              onChange: (value) {
                _firstname = value.toString();
              },
            ),
            CustomInputField(
              hint: "Last Name",
              keyboardType: TextInputType.name,
              isPasswordField: false,
              controller: lastname_controller,
              onChange: (value) {
                _lastname = value.toString();
              },
            ),
            CustomInputField(
              hint: "Phone Number",
              isPasswordField: false,
              controller: phone_controller,
              onChange: (value) {
                _phone = value.toString();
              },
              keyboardType: TextInputType.phone,
              prefix: CountryCodePicker(
                onChanged: (value) {
                  _country_code = value.toString();
                },
                showFlag: true,
                showFlagMain: true,
                flagWidth: 25,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: '$_country_code',

                // optional. Shows only country name and flag
                showCountryOnly: true,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
            ),
            CustomInputField(
              hint: "Current Password",
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              onChange: (value) {
                _password = value.toString();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                // if (oldPickedImage == null) {
                //   showSnackBar("Profile Image required", context);
                //   return;
                // }

                if (!isPhoneValid(_phone, context, _country_code)) {
                  return;
                }

                if (_firstname.isEmpty ||
                    _lastname.isEmpty ||
                    _phone.isEmpty ||
                    _password.isEmpty) {
                  showSnackBar("All fields required", context);
                  return;
                }
//-----------------------Registration------------------------------------

                RegisteredUser registeredUser = RegisteredUser(
                    user_id: mUser!.user_id,
                    firstName: (_firstname),
                    lastName: (_lastname),
                    email: mUser!.email,
                    phone: _phone,
                    password: _password,
                    image_url: mUser!.image_url,
                    country_code: _country_code,
                    // 0,
                    // 0,
                    notification_token: mUser!.notification_token,
                    lastSeen: 0);

                setState(() {
                  showLoading = true;
                });

                AuthCredential authCredential = EmailAuthProvider.credential(
                    email: mUser!.email, password: _password);

                FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(authCredential)
                    .then((value) {})
                    .catchError((error) {
                  showSnackBar(error.toString(), context);
                  if (FirebaseAuth.instance.currentUser != null) {
                    FirebaseAuth.instance.signOut().then((value) {
                      closeAllScreens(context);
                      openScreen(context, AuthenticationScreen());
                    });
                  }
                  setState(() {
                    showLoading = false;
                  });
                  return;
                });

                if (registeredUser.phone == mUser!.phone) {
                  return;
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdatePhoneOtpScreen(
                              userObject: registeredUser,
                              imageFile: oldPickedImage,
                            )));
              },
              child: Text("Update"),
              style: redButtonStyle,
            ),
            KhaliWidget(20),
            Text(
              "Warning: You'll be logged out on entering wrong password!",
              style: red_h3Style_bold,
            ),
            KhaliWidget(60),
          ],
        ),
      ),
    );
  }

  @override
  void dataReceived(RegisteredUser? registeredUser) {
    mUser = registeredUser;
    setState(() {
      showLoading = (mUser == null || mUser!.user_id.isEmpty);
    });
  }
}
