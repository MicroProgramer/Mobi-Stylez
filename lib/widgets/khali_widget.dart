import 'package:flutter/material.dart';

class KhaliWidget extends StatefulWidget {
  double space;

  KhaliWidget(this.space);

  @override
  _KhaliWidgetState createState() => _KhaliWidgetState();
}

class _KhaliWidgetState extends State<KhaliWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.space),
    );
  }
}
