import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'timeline_entry_card.dart';

class MoodTimeline extends StatefulWidget {
  const MoodTimeline({
    super.key,
    required this.entries,
  });

  final List<MoodEntry> entries;

  @override
  State<MoodTimeline> createState() => _MoodTimelineState();
}

class _MoodTimelineState extends State<MoodTimeline> {
  final Map<int, GlobalKey<TimelineEntryCardState>> _cardKeys = {};

  GlobalKey<TimelineEntryCardState> _keyForIndex(int index) {
    return _cardKeys.putIfAbsent(index, GlobalKey<TimelineEntryCardState>.new);
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'Your last 7 moods will appear here',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(width: 0),
      itemBuilder: (context, index) {
        final key = _keyForIndex(index);
        return TimelineEntryCard(
          key: key,
          entry: entries[index],
        );
      },
    );
  }
}
