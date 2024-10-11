import 'package:flutter/material.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/helper/painters.dart';

class SignShapeBackground extends StatelessWidget {
  const SignShapeBackground(
      {super.key, required this.child, required this.clipper});

  final Widget child;
  final SignClipper clipper;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: clipper,
          child:
              child, // Container(color: const Color.fromARGB(255, 196, 153, 255)),
        ),
        CustomPaint(
          painter: ShadowPainter(
              clipper: clipper,
              shadowOffset: const Offset(0, 12),
              shadowSize: 2),
          child: Container(
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }
}
