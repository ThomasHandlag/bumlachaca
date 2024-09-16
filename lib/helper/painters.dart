import 'package:flutter/material.dart';

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
