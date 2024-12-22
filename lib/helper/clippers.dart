import 'package:flutter/material.dart';

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;
    path.lineTo(0 * xScaling, 0 * yScaling);
    path.cubicTo(
      0 * xScaling,
      0 * yScaling,
      430 * xScaling,
      0 * yScaling,
      430 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      430 * xScaling,
      0 * yScaling,
      430 * xScaling,
      683.5 * yScaling,
      430 * xScaling,
      683.5 * yScaling,
    );
    path.cubicTo(
      430 * xScaling,
      683.5 * yScaling,
      352.579 * xScaling,
      747 * yScaling,
      357.5 * xScaling,
      592 * yScaling,
    );
    path.cubicTo(
      362.421 * xScaling,
      437 * yScaling,
      345 * xScaling,
      603.5 * yScaling,
      281.5 * xScaling,
      562.5 * yScaling,
    );
    path.cubicTo(
      218 * xScaling,
      521.5 * yScaling,
      312 * xScaling,
      442 * yScaling,
      156 * xScaling,
      496 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      550 * yScaling,
      0 * xScaling,
      442 * yScaling,
      0 * xScaling,
      442 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      442 * yScaling,
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class VisualizerClipper extends CustomClipper<Path> {
  final double? radius;
  const VisualizerClipper({this.radius = 10.0});
  @override
  Path getClip(Size size) {
    // final double xScaling = size.width / 414;
    // final double yScaling = size.height / 896;

    // Create a rectangle with rounded corners using RRect
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius!),
    );

    final path = Path()..addRRect(rrect);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SignClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width * 0.12, size.height / 5, size.width / 5,
        size.height * 0.27);
    path.cubicTo(size.width * 0.31, size.height * 0.34, size.width * 0.34,
        size.height * 0.35, size.width * 0.62, size.height * 0.35);
    path.cubicTo(size.width * 0.91, size.height * 0.35, size.width,
        size.height * 0.46, size.width, size.height * 0.46);
    path.cubicTo(size.width, size.height * 0.46, size.width, size.height,
        size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, 0, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
