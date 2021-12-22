import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemSentMessage extends StatefulWidget {
  @override
  _ItemSentMessageState createState() => _ItemSentMessageState();
}

class _ItemSentMessageState extends State<ItemSentMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Color(0xF0E7F0FF),
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
              SvgPicture.asset('assets/icon_read.svg'),
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
