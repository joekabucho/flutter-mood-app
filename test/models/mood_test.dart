import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/models/mood.dart';

void main() {
  group('Mood', () {
    test('has three values', () {
      expect(Mood.values, hasLength(3));
      expect(Mood.values, containsAll([Mood.happy, Mood.neutral, Mood.sad]));
    });

    test('labels are human readable', () {
      expect(Mood.happy.label, 'Happy');
      expect(Mood.neutral.label, 'Neutral');
      expect(Mood.sad.label, 'Sad');
    });

    test('each mood has distinct accent colors', () {
      final accents = Mood.values.map((m) => m.accent).toSet();
      expect(accents, hasLength(3));
    });

    test('each mood has distinct face fill colors', () {
      final fills = Mood.values.map((m) => m.faceFill).toSet();
      expect(fills, hasLength(3));
    });

    test('each mood has distinct stroke colors', () {
      final strokes = Mood.values.map((m) => m.stroke).toSet();
      expect(strokes, hasLength(3));
    });

    test('happy uses warm palette', () {
      expect(Mood.happy.accent, const Color(0xFFFFB74D));
      expect(Mood.happy.faceFill, const Color(0xFFFFF176));
    });
  });
}
