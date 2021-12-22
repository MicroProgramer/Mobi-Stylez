import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/widgets/header_container_design.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../main_screen.dart';

class UpdatePhoneOtpScreen extends StatefulWidget {
  RegisteredUser userObject;
  XFile? imageFile;

  UpdatePhoneOtpScreen({required this.userObject, this.imageFile});

  @override
  _UpdatePhoneOtpScreenState createState() => _UpdatePhoneOtpScreenState();
}

class _UpdatePhoneOtpScreenState extends State<UpdatePhoneOtpScreen> {
  String _code = "";
  var _auth = FirebaseAuth.instance;
  String _verificationId = "";
  int _resendToken = 0;
  bool isButtonEnabled = false;
  bool showSpinner = false;
  TextEditingController pin_code_controller = TextEditingController();

  @override
  void initState() {
    _auth.verifyPhoneNumber(
      phoneNumber: (widget.userObject.country_code + widget.userObject.phone),
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          pin_code_controller.text = credential.smsCode ?? "";
          showSpinner = true;
        });

        _auth.currentUser!
            .updatePhoneNumber(credential)
            .then((value) => verificationCompleted())
            .catchError((error) {
          setState(() {
            showSnackBar(error.toString(), context);
            showSpinner = false;
          });
        });

        _auth
            .signInWithCredential(credential)
            .then((value) {})
            .catchError((error) {
          showSnackBar(error.toString(), context);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar(e.message.toString(), context);
        Navigator.pop(context);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken!;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: HeaderContainerDesign(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "We have sent an OTP to your mobile",
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Please check mobile number (${widget.userObject.phone}) for OTP",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: PinCodeTextField(
                  enablePinAutofill: true,
                  hintCharacter: '*',
                  controller: pin_code_controller,
                  onChanged: (String value) {
                    _code = value;
                    setState(() {
                      isButtonEnabled = (value.length == 6);
                    });
                  },
                  length: 6,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  appContext: context,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  return isButtonEnabled ? verifyPin(_code) : null;
                },
                child: Text("Next"),
                style: isButtonEnabled ? redButtonStyle : disabledButtonStyle,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't Receive? "),
                    GestureDetector(
                      child: Text("Click Here", style: red_h2Style_bold),
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void verifyPin(String pin) async {
    setState(() {
      showSpinner = true;
    });

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pin);

    try {
      await _auth.currentUser!
          .updatePhoneNumber(phoneAuthCredential)
          .then((value) => verificationCompleted());
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message.toString(), context);
    }
  }

  Future<void> verificationCompleted() async {
    setState(() {
      showSpinner = true;
    });

    showSnackBar("Verification Completed, Updating Profile", context);
    await updateStatusInDatabase();

    Navigator.popUntil(context, (route) => false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MainScreen()));
  }

  Future<void> updateStatusInDatabase() async {
    try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
      widget.userObject.user_id = uid;

      if (widget.imageFile != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child("profile_images/${uid}.png");
        final UploadTask uploadTask =
            storageReference.putFile(File(widget.imageFile!.path));

        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            // _progress = event.snapshot.bytesTransferred.toDouble() /
            //     event.snapshot.totalByteCount.toDouble();
              showSpinner = true;
          });
        }).onError((error) {
          // do something to handle error
          setState(() {
            showSpinner = false;
          });
        });

        final TaskSnapshot downloadUrl = (await uploadTask);
        final String url = await downloadUrl.ref.getDownloadURL();
        widget.userObject.image_url = url;
      }

      usersRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(widget.userObject.toMap());

// -------------------------------Uploading to database--------------------

    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
