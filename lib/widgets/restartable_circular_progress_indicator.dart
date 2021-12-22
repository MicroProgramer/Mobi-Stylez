import 'package:firebase_auth_practice/widgets/progress_controller.dart';
import 'package:flutter/material.dart';

class RestartableCircularProgressIndicator extends StatefulWidget {
  final ProgressController controller;
  final VoidCallback onTimeout;

  RestartableCircularProgressIndicator({
    required this.controller,
    required this.onTimeout,
  });

  @override
  _RestartableCircularProgressIndicatorState createState() =>
      _RestartableCircularProgressIndicatorState();
}

class _RestartableCircularProgressIndicatorState
    extends State<RestartableCircularProgressIndicator> {
  ProgressController get controller => widget.controller;

  VoidCallback get onTimeout => widget.onTimeout;

  @override
  void initState() {
    super.initState();
    controller.progressStream.listen((_) => updateState());
    controller.timeoutStream.listen((_) => onTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: controller.progress,
    );
  }

  void updateState() => setState(() {});
}
