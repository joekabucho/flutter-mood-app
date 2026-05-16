import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/models/mood_entry.dart';

void main() {
  group('MoodEntry', () {
    test('stores mood and timestamp', () {
      final loggedAt = DateTime(2026, 5, 15, 14, 30);
      final entry = MoodEntry(mood: Mood.neutral, loggedAt: loggedAt);

      expect(entry.mood, Mood.neutral);
      expect(entry.loggedAt, loggedAt);
    });

    test('two entries with same values share equal fields', () {
      final a = MoodEntry(mood: Mood.happy, loggedAt: DateTime(2026, 1, 1));
      final b = MoodEntry(mood: Mood.happy, loggedAt: DateTime(2026, 1, 1));

      expect(a.mood, b.mood);
      expect(a.loggedAt, b.loggedAt);
    });
  });
}
