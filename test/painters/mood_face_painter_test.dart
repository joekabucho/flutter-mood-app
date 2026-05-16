import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/painters/mood_face_painter.dart';

void main() {
  group('MoodFacePainter', () {
    test('paints without error for every mood', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(80, 80);

      for (final mood in Mood.values) {
        MoodFacePainter(mood: mood).paint(canvas, size);
      }

      expect(recorder.endRecording(), isNotNull);
    });

    test('paints with blink and reaction parameters', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      MoodFacePainter(
        mood: Mood.happy,
        blink: 1,
        reaction: 1,
      ).paint(canvas, const Size(80, 80));

      expect(recorder.endRecording(), isNotNull);
    });

    test('shouldRepaint when mood changes', () {
      final a = MoodFacePainter(mood: Mood.happy);
      final b = MoodFacePainter(mood: Mood.sad);

      expect(a.shouldRepaint(b), isTrue);
    });

    test('shouldRepaint when blink or reaction changes', () {
      final base = MoodFacePainter(mood: Mood.neutral);
      final blinked = MoodFacePainter(mood: Mood.neutral, blink: 0.5);
      final reacting = MoodFacePainter(mood: Mood.neutral, reaction: 0.8);

      expect(base.shouldRepaint(blinked), isTrue);
      expect(base.shouldRepaint(reacting), isTrue);
    });

    test('shouldNotRepaint when delegate is unchanged', () {
      final a = MoodFacePainter(mood: Mood.happy, blink: 0.2, reaction: 0.3);
      final b = MoodFacePainter(mood: Mood.happy, blink: 0.2, reaction: 0.3);

      expect(a.shouldRepaint(b), isFalse);
    });

    test('shouldRepaint when strokeWidth changes', () {
      final thin = MoodFacePainter(mood: Mood.happy, strokeWidth: 2);
      final thick = MoodFacePainter(mood: Mood.happy, strokeWidth: 4);

      expect(thin.shouldRepaint(thick), isTrue);
    });
  });
}
