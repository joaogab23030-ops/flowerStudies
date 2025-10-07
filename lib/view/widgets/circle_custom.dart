import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Cor do semicírculo
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 240, 73, 129);

    final Path path = Path();

    path.lineTo(0, 0);

    double sideHeight = size.height * 0.25;
    path.lineTo(0, sideHeight);

    double baseDip = size.height * 0.40;
    double waveAmplitude = 20.0;

    double controlX = size.width / 2;
    double controlY =
        baseDip + (waveAmplitude * math.sin(animationValue * 2 * math.pi));

    double endX = size.width;
    double endY = sideHeight;

    path.quadraticBezierTo(controlX, controlY, endX, endY);

    path.lineTo(size.width, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
