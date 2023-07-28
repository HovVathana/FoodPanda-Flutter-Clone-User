import 'package:flutter/material.dart';

class CustomLinearProgress extends StatefulWidget {
  final bool isDone;
  final bool isProgess;
  const CustomLinearProgress(
      {super.key, required this.isDone, required this.isProgess});

  @override
  State<CustomLinearProgress> createState() => _CustomLinearProgress();
}

class _CustomLinearProgress extends State<CustomLinearProgress>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: widget.isDone
            ? 1
            : widget.isProgess
                ? controller.value
                : 0,
        semanticsLabel: 'Linear progress indicator',
      ),
    );
  }
}
