import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fftea/fftea.dart';

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
      ..color = Colors.black.withAlpha(255 ~/ 2)
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
      required this.data,
      required this.isPlaying});
  final CustomClipper<Path> clipper;
  final List<double>? data;
  final double deltaTime;
  final bool isPlaying;

  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);
    int barCount = 64;
    final Paint backgroundPaint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, backgroundPaint);

    final barPainter = Paint()
      ..color = const Color.fromARGB(220, 50, 234, 255)
      ..style = PaintingStyle.fill;

    const chunkSize = 44100;
    final stft = STFT(chunkSize, Window.hanning(chunkSize));
    final spectrogram = <Float64List>[];
    if (data != null) {
      stft.run(data!, (Float64x2List freq) {
        spectrogram.add(freq.discardConjugates().magnitudes());
      });
    }

    final maxPeaks = List<double>.filled(barCount, 0.0);
    final binSize = spectrogram[0].length ~/ barCount;

    for (final frame in spectrogram) {
      for (int i = 0; i < barCount; i++) {
        final startIdx = i * binSize;
        final endIdx = (i + 1) * binSize;
        final bin = frame.sublist(startIdx, endIdx);

        final peak =
            bin.reduce((value, element) => element > value ? element : value);
        maxPeaks[i] = maxPeaks[i] > peak ? maxPeaks[i] : peak;
      }
    }
    double barWidth = size.width / (barCount * 1.5);
    double spacing = barWidth / 2; // Spacing between bars

    if (data != null) {
      for (int i = 0; i < barCount; i++) {
        final value =
            maxPeaks[i].abs() * size.height / maxPeaks.reduce(max) * 40;
        double barHeight = value * deltaTime;
        if (barHeight > size.height) {
          barHeight = size.height;
        }
        double x = i * (barWidth + spacing);
        final Rect barRect =
            Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
        canvas.drawRect(barRect, barPainter);
      }
    }

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withAlpha(255 ~/ 2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    path.shift(const Offset(-0, 10));
    // Draw the shadow
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(VisualzerPainter oldDelegate) =>
      isPlaying && data != oldDelegate.data;
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
