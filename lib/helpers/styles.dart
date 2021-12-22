import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color hintColor = Color(0xF06B6B6B);
Color listFillColor = Color(0xF0F6F6F6);
Color opacityGrey = Color(0xC1707070);

ButtonStyle redButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.red,
  onPrimary: Colors.white,
  shadowColor: Colors.redAccent,
  padding: EdgeInsets.all(10),
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
  minimumSize: Size(100, 40),
);
ButtonStyle redButtonProfileStyle = ElevatedButton.styleFrom(
  primary: Colors.red,
  onPrimary: Colors.white,
  shadowColor: Colors.redAccent,
  elevation: 3,
  minimumSize: Size(400, 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
);

ButtonStyle inverseRedButtonProfileStyle = ElevatedButton.styleFrom(
  primary: Colors.white,
  onPrimary: Colors.red,
  minimumSize: Size(400, 30),
  elevation: 0,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(color: Colors.red, width: 1)),
);

ButtonStyle redButtonProfileStyle_small = ElevatedButton.styleFrom(
  primary: Colors.red,
  onPrimary: Colors.white,
  shadowColor: Colors.redAccent,
  elevation: 3,
  minimumSize: Size(40, 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
);

ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.grey,
  onPrimary: Colors.white,
  shadowColor: Colors.grey,
  padding: EdgeInsets.all(10),
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
  minimumSize: Size(100, 40),
);
TextStyle headingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

TextStyle heading1_style = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
TextStyle heading2_style = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
TextStyle heading3_style = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
TextStyle heading4_style = TextStyle(fontSize: 19, fontWeight: FontWeight.bold);

TextStyle white_heading1_style =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle white_heading2_style =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle white_heading3_style =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle white_heading4_style =
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle normal_h1Style = TextStyle(fontSize: 19);
TextStyle normal_h2Style = TextStyle(fontSize: 17);
TextStyle normal_h3Style = TextStyle(fontSize: 15);
TextStyle normal_h4Style = TextStyle(fontSize: 13);
TextStyle normal_h5Style = TextStyle(fontSize: 11);
TextStyle normal_h6Style = TextStyle(fontSize: 9);

TextStyle normal_h1Style_bold =
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold);
TextStyle normal_h2Style_bold =
    TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
TextStyle normal_h3Style_bold =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
TextStyle normal_h4Style_bold =
    TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
TextStyle normal_h5Style_bold =
    TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
TextStyle normal_h6Style_bold =
    TextStyle(fontSize: 9, fontWeight: FontWeight.bold);

TextStyle red_h1Style = TextStyle(color: Colors.red, fontSize: 19);
TextStyle red_h2Style = TextStyle(color: Colors.red, fontSize: 17);
TextStyle red_h3Style = TextStyle(color: Colors.red, fontSize: 15);
TextStyle red_h4Style = TextStyle(color: Colors.red, fontSize: 13);

TextStyle red_h1Style_bold =
    TextStyle(color: Colors.red, fontSize: 19, fontWeight: FontWeight.bold);
TextStyle red_h2Style_bold =
    TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle red_h3Style_bold =
    TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold);

TextStyle grey_h1Style = TextStyle(color: opacityGrey, fontSize: 19);
TextStyle grey_h2Style = TextStyle(color: opacityGrey, fontSize: 17);
TextStyle grey_h3Style = TextStyle(color: opacityGrey, fontSize: 15);
TextStyle grey_h4Style = TextStyle(color: opacityGrey, fontSize: 13);
TextStyle grey_h5Style = TextStyle(color: opacityGrey, fontSize: 11);
TextStyle grey_h6Style = TextStyle(color: opacityGrey, fontSize: 9);

TextStyle grey_h1Style_bold =
    TextStyle(color: opacityGrey, fontSize: 19, fontWeight: FontWeight.bold);
TextStyle grey_h2Style_bold =
    TextStyle(color: opacityGrey, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle grey_h3Style_bold =
    TextStyle(color: opacityGrey, fontSize: 15, fontWeight: FontWeight.bold);

TextStyle white_h1Style_bold =
    TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold);
TextStyle white_h2Style_bold =
    TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle white_h3Style_bold =
    TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
