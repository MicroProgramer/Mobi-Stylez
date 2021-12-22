import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHeaderContainerDesign extends StatefulWidget {
  Widget child;
  Widget? bottomNavigationBar;
  AppBar? appBar;
  double? paddingTop;

  CustomHeaderContainerDesign(
      {required this.child,
      this.bottomNavigationBar,
      required this.appBar,
      this.paddingTop});

  @override
  _CustomHeaderContainerDesignState createState() =>
      _CustomHeaderContainerDesignState();
}

class _CustomHeaderContainerDesignState
    extends State<CustomHeaderContainerDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: widget.appBar,
      body: Container(
        padding: EdgeInsets.only(top: widget.paddingTop ?? 22),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: []),
        child: widget.child,
      ),
    );
  }
}
