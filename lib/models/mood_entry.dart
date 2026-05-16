import 'mood.dart';

class MoodEntry {
  const MoodEntry({
    required this.mood,
    required this.loggedAt,
  });

  final Mood mood;
  final DateTime loggedAt;
}
