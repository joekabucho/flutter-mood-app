import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/mood.dart';

/// Draws a mood face with [CustomPainter] primitives only — no images or emoji.
///
/// [blink] 0 = eyes open, 1 = fully closed.
/// [reaction] 0–1 drives a brief expression pulse (wider smile, deeper frown, etc.).
class MoodFacePainter extends CustomPainter {
  MoodFacePainter({
    required this.mood,
    this.strokeWidth = 2.4,
    this.blink = 0,
    this.reaction = 0,
  });

  final Mood mood;
  final double strokeWidth;
  final double blink;
  final double reaction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;
    final bounceY = -radius * 0.07 * math.sin(reaction * math.pi);

    canvas.save();
    canvas.translate(0, bounceY);

    _drawFace(canvas, center, radius);
    _drawEyebrows(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);

    if (mood == Mood.happy) {
      _drawCheeks(canvas, center, radius);
    } else if (mood == Mood.sad) {
      _drawTear(canvas, center, radius);
    }

    canvas.restore();
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    final fill = Paint()
      ..color = mood.faceFill
      ..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = mood.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final faceRadius = radius * (1 + 0.04 * reaction);
    canvas.drawCircle(center, faceRadius, fill);
    canvas.drawCircle(center, faceRadius, outline);
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = mood.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;

    final browY = center.dy - radius * (0.38 + 0.04 * reaction);
    final span = radius * 0.28;

    switch (mood) {
      case Mood.happy:
        for (final side in [-1.0, 1.0]) {
          final browCenter = Offset(center.dx + side * radius * 0.32, browY);
          final rect = Rect.fromCenter(
            center: browCenter,
            width: span * (1.4 + 0.2 * reaction),
            height: span * (0.9 + 0.15 * reaction),
          );
          canvas.drawArc(
            rect,
            math.pi * 0.15,
            math.pi * 0.7,
            false,
            paint,
          );
        }
      case Mood.neutral:
        for (final side in [-1.0, 1.0]) {
          final lift = radius * 0.05 * reaction;
          canvas.drawLine(
            Offset(center.dx + side * radius * 0.48 - span * 0.5, browY - lift),
            Offset(center.dx + side * radius * 0.48 + span * 0.5, browY - lift),
            paint,
          );
        }
      case Mood.sad:
        for (final side in [-1.0, 1.0]) {
          final droop = radius * 0.08 * reaction;
          final start = Offset(
            center.dx + side * radius * 0.18,
            browY - span * 0.2 + droop,
          );
          final end = Offset(
            center.dx + side * radius * 0.52,
            browY + span * 0.35 + droop,
          );
          canvas.drawLine(start, end, paint);
        }
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeY = center.dy - radius * 0.08;
    final eyeOffsetX = radius * 0.32;
    final eyePaint = Paint()
      ..color = mood.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (blink > 0.05) {
      final closedHeight = radius * 0.04 * (1 - blink * 0.3);
      for (final side in [-1.0, 1.0]) {
        canvas.drawLine(
          Offset(center.dx + side * eyeOffsetX - radius * 0.13, eyeY),
          Offset(center.dx + side * eyeOffsetX + radius * 0.13, eyeY + closedHeight),
          eyePaint..strokeWidth = strokeWidth * (1.1 + blink * 0.4),
        );
      }
      return;
    }

    switch (mood) {
      case Mood.happy:
        final dot = Paint()
          ..color = mood.stroke
          ..style = PaintingStyle.fill;
        final eyeRadius = radius * (0.09 + 0.03 * reaction);
        for (final side in [-1.0, 1.0]) {
          canvas.drawCircle(
            Offset(center.dx + side * eyeOffsetX, eyeY - radius * 0.02 * reaction),
            eyeRadius,
            dot,
          );
        }
      case Mood.neutral:
        for (final side in [-1.0, 1.0]) {
          canvas.drawLine(
            Offset(center.dx + side * eyeOffsetX - radius * 0.12, eyeY),
            Offset(center.dx + side * eyeOffsetX + radius * 0.12, eyeY),
            eyePaint,
          );
        }
      case Mood.sad:
        for (final side in [-1.0, 1.0]) {
          final eyeCenter = Offset(
            center.dx + side * eyeOffsetX,
            eyeY + radius * (0.04 + 0.06 * reaction),
          );
          final rect = Rect.fromCenter(
            center: eyeCenter,
            width: radius * 0.22,
            height: radius * (0.14 + 0.06 * reaction),
          );
          canvas.drawArc(rect, math.pi * 0.1, math.pi * 0.8, false, eyePaint);
        }
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthY = center.dy + radius * 0.28;
    final mouthPaint = Paint()
      ..color = mood.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * (1.1 + 0.3 * reaction)
      ..strokeCap = StrokeCap.round;

    switch (mood) {
      case Mood.happy:
        final smileRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY + radius * (0.06 - 0.04 * reaction)),
          width: radius * (0.72 + 0.12 * reaction),
          height: radius * (0.5 + 0.18 * reaction),
        );
        canvas.drawArc(
          smileRect,
          math.pi * 0.12,
          math.pi * (0.5 + 0.26 * reaction),
          false,
          mouthPaint,
        );
      case Mood.neutral:
        final curve = radius * 0.08 * reaction;
        final path = Path()
          ..moveTo(center.dx - radius * 0.28, mouthY)
          ..quadraticBezierTo(center.dx, mouthY - curve, center.dx + radius * 0.28, mouthY);
        canvas.drawPath(path, mouthPaint);
      case Mood.sad:
        final frownRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY - radius * (0.18 + 0.08 * reaction)),
          width: radius * (0.62 + 0.08 * reaction),
          height: radius * (0.42 + 0.14 * reaction),
        );
        canvas.drawArc(
          frownRect,
          math.pi * 1.12,
          math.pi * (0.6 + 0.16 * reaction),
          false,
          mouthPaint,
        );
    }
  }

  void _drawCheeks(Canvas canvas, Offset center, double radius) {
    final blush = Paint()
      ..color = const Color(0xFFFF8A65).withValues(alpha: 0.35 + 0.25 * reaction)
      ..style = PaintingStyle.fill;
    for (final side in [-1.0, 1.0]) {
      canvas.drawCircle(
        Offset(center.dx + side * radius * 0.55, center.dy + radius * 0.12),
        radius * (0.11 + 0.04 * reaction),
        blush,
      );
    }
  }

  void _drawTear(Canvas canvas, Offset center, double radius) {
    final dropY = radius * 0.22 * reaction;
    final tear = Path()
      ..moveTo(center.dx + radius * 0.38, center.dy - radius * 0.02 + dropY * 0.2)
      ..quadraticBezierTo(
        center.dx + radius * 0.44,
        center.dy + radius * 0.12 + dropY * 0.6,
        center.dx + radius * 0.36,
        center.dy + radius * 0.22 + dropY,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.32,
        center.dy + radius * 0.1 + dropY * 0.5,
        center.dx + radius * 0.38,
        center.dy - radius * 0.02 + dropY * 0.2,
      )
      ..close();

    canvas.drawPath(
      tear,
      Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.55 + 0.35 * reaction)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.blink != blink ||
        oldDelegate.reaction != reaction;
  }
}
