import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class ShadowPainter extends CustomPainter {
  const ShadowPainter(
      {required this.clipper, required this.shadowOffset, this.shadowSize = 5});
  final CustomClipper<Path> clipper;
  final Offset shadowOffset;
  final double? shadowSize;
  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = shadowSize!;
    canvas.drawPath(path.shift(shadowOffset), shadowPaint);
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(path.shift(shadowOffset), shadowPaint);
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
      ..color = const Color.fromARGB(220, 187, 129, 223)
      ..style = PaintingStyle.fill;

    int barCount = 32;
    // Bar width and spacing
    double barWidth = size.width / (barCount * 1.5); // Spacing between bars
    double spacing = barWidth / 2;
    sleep(const Duration(milliseconds: 50));

    // Draw each bar
    for (int i = 0; i < barCount; i++) {
      final Random random = Random();
      // Random height for each bar
      double barHeight = random.nextDouble() * size.height * sin(deltaTime);

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

class BarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    int barCount = 32;
    // Bar width and spacing
    double barWidth = size.width / (barCount * 1.5); // Spacing between bars
    double spacing = barWidth / 2;

    // Draw each bar
    for (int i = 0; i < barCount; i++) {
      final Random random = Random();
      // Random height for each bar
      double barHeight = random.nextDouble() * size.height;

      // Calculate the position of the bar
      double x = i * (barWidth + spacing);
      Rect barRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);

      // Draw the bar
      canvas.drawRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
