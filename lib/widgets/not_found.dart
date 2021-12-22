import 'package:flutter/material.dart';

class NotFound extends StatefulWidget {
  String message;
  String? assetImage;
  String? networkImageUrl;
  Color? color;
  double? imageHeight, imageWidth;

  @override
  _NotFoundState createState() => _NotFoundState();

  NotFound({
    required this.message,
    this.assetImage,
    this.networkImageUrl,
    this.color,
    this.imageHeight,
    this.imageWidth,
  });
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/nothing.png",
            color: widget.color,
            height:
                widget.imageHeight ?? MediaQuery.of(context).size.height * 0.1,
            width:
                widget.imageWidth ?? MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              widget.message,
              style: TextStyle(color: widget.color),
            ),
          ),
        ],
      ),
    );
  }
}
