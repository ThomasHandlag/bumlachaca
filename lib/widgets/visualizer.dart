import 'package:flutter/material.dart';
import 'package:usicat/helper/painters.dart';

class Visualizer extends StatefulWidget {
  const Visualizer(
      {super.key,
      required this.clipper,
      required this.width,
      required this.height});
  final CustomClipper<Path> clipper;
  final double width, height;
  @override
  State<StatefulWidget> createState() => VisualizerState();
}

class VisualizerState extends State<Visualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double _delta = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    controller.addListener(() {
      setState(() {
        _delta = animation.value;
      });
    });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          ClipPath(
            clipper: widget.clipper,
            child: CustomPaint(
              painter:
                  VisualzerPainter(clipper: widget.clipper, deltaTime: _delta),
              child: SizedBox(
                width: widget.width,
                height: widget.height,
              ),
            ),
          ),
        ],
      ));
}
