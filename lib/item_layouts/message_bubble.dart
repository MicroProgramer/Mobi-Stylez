import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final Type userType;
  final int timestamp;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();

  const MessageBubble({
    required this.text,
    required this.userType,
    required this.timestamp,
  });
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Column(
          crossAxisAlignment: widget.userType == Type.sender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                  topLeft: widget.userType == Type.sender
                      ? Radius.circular(30)
                      : Radius.circular(30),
                  topRight: widget.userType == Type.receiver
                      ? Radius.circular(30)
                      : Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: widget.userType == Type.sender
                  ? Color(0xF0E7F0FF)
                  : Color(0xF0EBEBEB),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        "${widget.text}",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                    Text(
                      timeStampToDateTime(
                          widget.timestamp, "hh:mm a, dd MMM yyyy"),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Type { sender, receiver }