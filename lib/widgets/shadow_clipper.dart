import 'package:flutter/material.dart';
import 'package:musicplayer/helper/painters.dart';

class ShadowClipper extends StatelessWidget {
  const ShadowClipper({super.key, required this.clipper, required this.child});
  final CustomClipper<Path> clipper;
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(children: [
        ClipPath(clipper: clipper, child: child),
        CustomPaint(
            painter: ShadowPainter(clipper: clipper),
            child: Container(
              width: MediaQuery.of(context).size.width,
            )),
      ]);
}
