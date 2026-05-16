import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/widgets/timeline_entry_card.dart';

void main() {
  group('MoodTrackerApp', () {
    testWidgets('loads title, picker labels, and empty timeline message',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MoodTrackerApp());

      expect(find.text('Mood Tracker'), findsOneWidget);
      expect(find.text('Tap how you feel right now'), findsOneWidget);
      expect(find.text('Past week'), findsOneWidget);
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Neutral'), findsOneWidget);
      expect(find.text('Sad'), findsOneWidget);
      expect(
        find.text('Your last 7 moods will appear here'),
        findsOneWidget,
      );
    });

    testWidgets('logging a mood adds a timeline card', (WidgetTester tester) async {
      await tester.pumpWidget(const MoodTrackerApp());

      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(TimelineEntryCard), findsOneWidget);
      expect(
        find.text('Your last 7 moods will appear here'),
        findsNothing,
      );
    });

    testWidgets('keeps at most seven timeline entries', (WidgetTester tester) async {
      await tester.pumpWidget(const MoodTrackerApp());

      for (var i = 0; i < 8; i++) {
        await tester.tap(find.text('Sad'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      expect(find.byType(TimelineEntryCard), findsNWidgets(7));
    });

    testWidgets('newest entry appears first in timeline', (WidgetTester tester) async {
      await tester.pumpWidget(const MoodTrackerApp());

      await tester.tap(find.text('Happy'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(find.text('Sad'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final cards = tester.widgetList<TimelineEntryCard>(
        find.byType(TimelineEntryCard),
      );

      expect(cards.first.entry.mood, Mood.sad);
      expect(cards.last.entry.mood, Mood.happy);
    });

    testWidgets('timeline card tap does not throw', (WidgetTester tester) async {
      await tester.pumpWidget(const MoodTrackerApp());

      await tester.tap(find.text('Neutral'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byType(TimelineEntryCard));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(TimelineEntryCard), findsOneWidget);
    });
  });
}
