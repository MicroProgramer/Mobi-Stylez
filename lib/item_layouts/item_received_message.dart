import 'package:flutter/material.dart';

import '../helpers/styles.dart';

class ItemReceivedMessage extends StatefulWidget {
  @override
  _ItemReceivedMessageState createState() => _ItemReceivedMessageState();
}

class _ItemReceivedMessageState extends State<ItemReceivedMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Color(0xF0EBEBEB),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, about that party!... 😅 ",
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // SvgPicture.asset('assets/icon_read.svg'),
              Text(
                "11:03",
                style: normal_h3Style,
              )
            ],
          )
        ],
      ),
    );
  }
}
