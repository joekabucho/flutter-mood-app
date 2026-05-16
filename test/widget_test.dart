import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/main.dart';

void main() {
  testWidgets('Mood tracker loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodTrackerApp());
    expect(find.text('Mood Tracker'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Neutral'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);
  });
}
