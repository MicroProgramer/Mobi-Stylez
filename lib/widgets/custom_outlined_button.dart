import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatefulWidget {
  Color color;
  Widget child;
  VoidCallback onPressed;
  double width;

  @override
  _CustomOutlinedButtonState createState() => _CustomOutlinedButtonState();

  CustomOutlinedButton({
    required this.color,
    required this.child,
    required this.onPressed,
    required this.width,
  });
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: widget.width, color: widget.color),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 50,
        child: widget.child,
      ),
    );
  }
}
