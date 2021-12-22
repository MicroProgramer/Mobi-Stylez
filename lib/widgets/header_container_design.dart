import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderContainerDesign extends StatefulWidget {
  Widget child;
  Widget? bottomNavigationBar;
  List<Widget>? appBarActions;

  HeaderContainerDesign(
      {required this.child, bottomNavigationBar, appBarActions});

  @override
  _HeaderContainerDesignState createState() => _HeaderContainerDesignState();
}

class _HeaderContainerDesignState extends State<HeaderContainerDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 200,
        actions: widget.appBarActions,
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/logo_large.png'),
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Text(
              appName,
              style: TextStyle(
                fontFamily: 'Qwigley',
                fontSize: 30,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 255, 128, 128),
                  ),
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: []),
        child: Container(margin: EdgeInsets.only(top: 20), child: widget.child),
      ),
    );
  }
}
