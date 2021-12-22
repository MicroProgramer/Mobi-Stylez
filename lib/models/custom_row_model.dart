import 'package:flutter/material.dart';

class CustomRowModel {
  bool selected;
  String title;

  CustomRowModel({required this.selected, required this.title});
}

class CustomRow extends StatelessWidget {
  final CustomRowModel model;

  CustomRow(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
// I have used my own CustomText class to customise TextWidget.
          Text(
            model.title,
          ),
          this.model.selected
              ? Icon(
                  Icons.radio_button_checked,
                  color: Colors.amber,
                )
              : Icon(Icons.radio_button_unchecked),
        ],
      ),
    );
  }
}
