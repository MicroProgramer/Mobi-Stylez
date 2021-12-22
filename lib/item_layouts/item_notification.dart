import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemNotification extends StatefulWidget {
  bool isRead;

  ItemNotification({required this.isRead});

  @override
  _ItemNotificationState createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.isRead ? listFillColor : Colors.transparent,
      leading: Hero(
        tag: "stylist_dp",
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
              "https://static.wikia.nocookie.net/mrbean/images/4/4b/Mr_beans_holiday_ver2.jpg/revision/latest?cb=20181130033425"),
        ),
      ),
      title: Text(
        "Flaan request has been accepted",
        style: normal_h3Style,
      ),
      subtitle: Text(
        "2 hours ago",
        style: TextStyle(
          color: hintColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
