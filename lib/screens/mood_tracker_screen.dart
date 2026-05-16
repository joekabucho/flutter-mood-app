import 'package:flutter/material.dart';

import '../models/mood.dart';
import '../models/mood_entry.dart';
import '../widgets/mood_picker.dart';
import '../widgets/mood_timeline.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  static const int _maxEntries = 7;

  final List<MoodEntry> _entries = [];

  void _logMood(Mood mood) {
    setState(() {
      _entries.insert(
        0,
        MoodEntry(mood: mood, loggedAt: DateTime.now()),
      );
      if (_entries.length > _maxEntries) {
        _entries.removeRange(_maxEntries, _entries.length);
      }
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Logged: ${mood.label}'),
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          backgroundColor: mood.stroke,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood Tracker',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap how you feel right now',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF607D8B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            MoodPicker(onMoodSelected: _logMood),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Past week',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF455A64),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: MoodTimeline(entries: _entries),
            ),
          ],
        ),
      ),
    );
  }
}
