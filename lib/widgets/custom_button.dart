import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  Color color;
  Widget child;
  VoidCallback onPressed;

  CustomButton(
      {required this.color, required this.child, required this.onPressed});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
