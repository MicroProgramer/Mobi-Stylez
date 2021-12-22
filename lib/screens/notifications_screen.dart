import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/item_layouts/item_notification.dart';
import 'package:firebase_auth_practice/screens/settings_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  ScrollController controller = ScrollController();
  double topContainer = 0;

  @override
  void initState() {
    controller.addListener(() {
      double value = controller.offset / 70;

      setState(() {
        topContainer = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainerDesign(
      appBar: AppBar(
        elevation: 0,
        title: Text("Notifications"),
        actions: [
          IconButton(
              onPressed: () {
                openScreen(context, SettingsScreen());
              },
              icon: Icon(Icons.settings))
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: 15,
          controller: controller,
          itemBuilder: (context, index) {
            bool read = (index % 2 == 0);
            double scale = 1.0;

            if (topContainer > 0.5) {
              scale = index + 0.5 - topContainer;

              if (scale < 0) {
                scale = 0;
              } else if (scale > 1) {
                scale = 1;
              }
            }

            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()..scale(scale, scale),
              child: Align(
                alignment: Alignment.topCenter,
                child: ItemNotification(isRead: read),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
            );
          },
        ),
      ),
    );
  }
}
