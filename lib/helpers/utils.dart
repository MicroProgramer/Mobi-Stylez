import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

Future<BitmapDescriptor> getMarkerImageFromUrl(
  String url, {
  required int targetWidth,
}) async {
  assert(url != null);
  final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
  if (targetWidth != null) {
    return convertImageFileToBitmapDescriptor(markerImageFile,
        size: targetWidth);
  } else {
    Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    return BitmapDescriptor.fromBytes(markerImageBytes);
  }
}

Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(File imageFile,
    {int size = 100,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10,
    Color titleColor = Colors.transparent,
    Color titleBackgroundColor = Colors.transparent}) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color;
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  final double radius = size / 2;

//make canvas clip path to prevent image drawing over the circle
  final Path clipPath = Path();
  clipPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Radius.circular(100)));
  clipPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
      Radius.circular(100)));
  canvas.clipPath(clipPath);

//paintImage
  final Uint8List imageUint8List = await imageFile.readAsBytes();

  final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);

  final ui.FrameInfo imageFI = await codec.getNextFrame();
  paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      image: imageFI.image);

//convert canvas as PNG bytes
  final _image =
      await pictureRecorder.endRecording().toImage(size, (size * 1.1).toInt());

  final data = await _image.toByteData(format: ui.ImageByteFormat.png);

//convert PNG bytes as BitmapDescriptor
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}

num doubleWithoutDecimalToInt(double val) {
  return val % 1 == 0 ? val.toInt() : val;
}

String timeStampToDateTime(int timestamp, String pattern) {
  return intl.DateFormat(pattern)
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

double roundDouble(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

void launchMail(
    {required String toMailId,
    required String subject,
    required String body}) async {
  var url = 'mailto:$toMailId?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void showOptionsBottomSheet(
    {required BuildContext context,
    required Text title,
    required List<ListTile> options}) {
  List<Widget> optionsWithTitle = [];
  optionsWithTitle.add(title);
  optionsWithTitle.addAll(options);
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: optionsWithTitle,
        );
      });
}
