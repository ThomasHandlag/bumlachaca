import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ShadowPainter extends CustomPainter {
  const ShadowPainter({required this.clipper});
  final CustomClipper<Path> clipper;
  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    // Draw the shadow
    canvas.drawPath(path.shift(const Offset(0, -10)), shadowPaint);

    // Clip the inner part to create the inner shadow effect
    canvas.saveLayer(Offset.zero & size, Paint());

    // Subtract the inner area from the shadow (inner shadow effect)
    canvas.drawPath(path.shift(const Offset(0, -10)), shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VisualzerPainter extends CustomPainter {
  VisualzerPainter({required this.clipper, required this.deltaTime});
  final CustomClipper<Path> clipper;
  final double deltaTime;

  @override
  void paint(Canvas canvas, Size size) {
    final barPainter = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    int barCount = 32;
    // Bar width and spacing
    double barWidth = size.width / (barCount * 1.5); // Spacing between bars
    double spacing = barWidth / 2;

    // Draw each bar
    for (int i = 0; i < barCount; i++) {
      final Random random = Random();
      // Random height for each bar
      double barHeight = random.nextDouble() * size.height * deltaTime;

      // Calculate the position of the bar
      double x = i * (barWidth + spacing);
      Rect barRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);

      // Draw the bar
      canvas.drawRect(barRect, barPainter);
    }

    var path = clipper.getClip(size);
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    path.shift(const Offset(-20, -10));
    // Draw the shadow
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(VisualzerPainter oldDelegate) =>
      oldDelegate.deltaTime != deltaTime;
}
