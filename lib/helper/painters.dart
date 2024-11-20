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
  VisualzerPainter(
      {required this.clipper,
      required this.deltaTime,
      required this.isPlaying});
  final CustomClipper<Path> clipper;
  final double deltaTime;
  final bool isPlaying;

  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);

    final Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, backgroundPaint);

    final barPainter = Paint()
      ..color = const Color.fromARGB(220, 187, 129, 223)
      ..style = PaintingStyle.fill;

    int barCount = 32;
    // Bar width and spacing
    double barWidth = size.width / (barCount * 1.5); // Spacing between bars
    double spacing = barWidth / 2;
    sleep(const Duration(milliseconds: 30));

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

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    path.shift(const Offset(-0, 10));
    // Draw the shadow
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(VisualzerPainter oldDelegate) => isPlaying;
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

class BallPainter extends CustomPainter {
  BallPainter({required this.position, required this.radius});
  Offset position;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, paint);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Draw the shadow
    canvas.drawCircle(position + const Offset(0, 0), radius, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant BallPainter oldDelegate) =>
      oldDelegate.position != position;
}
