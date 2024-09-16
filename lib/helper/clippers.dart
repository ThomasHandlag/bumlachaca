import 'package:flutter/material.dart';

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(0 * _xScaling, 0 * _yScaling);
    path.cubicTo(
      0 * _xScaling,
      0 * _yScaling,
      430 * _xScaling,
      0 * _yScaling,
      430 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      430 * _xScaling,
      0 * _yScaling,
      430 * _xScaling,
      683.5 * _yScaling,
      430 * _xScaling,
      683.5 * _yScaling,
    );
    path.cubicTo(
      430 * _xScaling,
      683.5 * _yScaling,
      352.579 * _xScaling,
      747 * _yScaling,
      357.5 * _xScaling,
      592 * _yScaling,
    );
    path.cubicTo(
      362.421 * _xScaling,
      437 * _yScaling,
      345 * _xScaling,
      603.5 * _yScaling,
      281.5 * _xScaling,
      562.5 * _yScaling,
    );
    path.cubicTo(
      218 * _xScaling,
      521.5 * _yScaling,
      312 * _xScaling,
      442 * _yScaling,
      156 * _xScaling,
      496 * _yScaling,
    );
    path.cubicTo(
      0 * _xScaling,
      550 * _yScaling,
      0 * _xScaling,
      442 * _yScaling,
      0 * _xScaling,
      442 * _yScaling,
    );
    path.cubicTo(
      0 * _xScaling,
      442 * _yScaling,
      0 * _xScaling,
      0 * _yScaling,
      0 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      0 * _xScaling,
      0 * _yScaling,
      0 * _xScaling,
      0 * _yScaling,
      0 * _xScaling,
      0 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
