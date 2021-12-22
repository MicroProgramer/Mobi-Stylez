import 'dart:async';
import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/screens/registration/reset_password/new_password_screen.dart';
import 'package:firebase_auth_practice/widgets/header_container_design.dart';
import 'package:firebase_auth_practice/widgets/progress_controller.dart';
import 'package:firebase_auth_practice/widgets/restartable_circular_progress_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../main_screen/main_screen.dart';

class CodeSentScreen extends StatefulWidget {
  RegisteredUser userObject;
  XFile? imageFile;
  bool resetPassword;

  CodeSentScreen(
      {required this.userObject, this.imageFile, required this.resetPassword});

  @override
  _CodeSentScreenState createState() => _CodeSentScreenState();
}

class _CodeSentScreenState extends State<CodeSentScreen> {
  String _code = "";
  var _auth = FirebaseAuth.instance;
  String _verificationId = "";
  int _resendToken = 0;
  bool isButtonEnabled = false;
  bool showSpinner = false;
  bool showResend = false;
  TextEditingController pin_code_controller = TextEditingController();
  CountDownController controller = CountDownController();

  @override
  void initState() {


    sendVerificationCode();

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
                  child: showResend
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Didn't Receive? "),
                            GestureDetector(
                              child:
                                  Text("Click Here", style: red_h2Style_bold),
                              onTap: () async {
                                await sendVerificationCode();
                                setState(() {
                                  showResend = false;
                                  controller.restart(duration: 60);
                                });
                                showSnackBar("Code resent", context);
                              },
                            ),
                          ],
                        )
                      : CircularCountDownTimer(
                          width: MediaQuery.of(context).size.height * 0.08,
                          height: MediaQuery.of(context).size.height * 0.08,
                          duration: 60,
                          isReverse: true,
                          controller: controller,
                          isReverseAnimation: true,
                          onComplete: (){
                            setState(() {
                              showResend = true;
                            });
                          },
                          fillColor: Colors.red,
                          ringColor: Colors.redAccent))
            ],
          ),
        ),
      ),
    );
  }

  void verifyPin(String pin) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pin);

    try {
      await _auth
          .signInWithCredential(phoneAuthCredential)
          .then((value) => verificationCompleted());
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message.toString(), context);
    }
  }

  Future<void> verificationCompleted() async {
    if (!widget.resetPassword) {
      showSnackBar("Phone Verified, Creating Account", context);
      await updateStatusInDatabase();

      Navigator.popUntil(context, (route) => false);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      openScreen(context, NewPasswordScreen());
      return;
    }
  }

  Future<void> updateStatusInDatabase() async {
    try {
      setState(() {
        showSpinner = true;
      });

      AuthCredential authCredential = EmailAuthProvider.credential(
          email: widget.userObject.email, password: widget.userObject.password);

      final user = await _auth.currentUser!
          .linkWithCredential(authCredential)
          .then((value) async {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        widget.userObject.user_id = uid;

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
        usersRef
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(widget.userObject.toMap());
      });

// -------------------------------Uploading to database--------------------

    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: (widget.userObject.country_code + widget.userObject.phone),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.signInWithCredential(credential).then((value) {
          setState(() {
            pin_code_controller.text = credential.smsCode ?? "";
          });
          verificationCompleted();
        }).catchError((error) {
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
  }
}
