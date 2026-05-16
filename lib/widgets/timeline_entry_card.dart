import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'mood_face.dart';

class TimelineEntryCard extends StatefulWidget {
  const TimelineEntryCard({
    super.key,
    required this.entry,
    this.faceSize = 56,
    this.onTap,
  });

  final MoodEntry entry;
  final double faceSize;
  final VoidCallback? onTap;

  @override
  State<TimelineEntryCard> createState() => TimelineEntryCardState();
}

class TimelineEntryCardState extends State<TimelineEntryCard>
    with TickerProviderStateMixin {
  final GlobalKey<MoodFaceState> _faceKey = GlobalKey<MoodFaceState>();

  late final AnimationController _pulseController;
  late final AnimationController _hoverController;
  late final Animation<double> _tapScale;
  late final Animation<double> _wiggle;
  late final Animation<double> _hover;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _tapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.96), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    ));
    _wiggle = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.08), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -0.08, end: 0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _hover = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _setHovered(bool hovered) {
    if (_isHovered == hovered) return;
    setState(() => _isHovered = hovered);
    if (hovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
    _faceKey.currentState?.setHovered(hovered);
  }

  void playTapAnimation() {
    _pulseController.forward(from: 0);
    _faceKey.currentState?.playReaction();
    widget.onTap?.call();
  }

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static String _formatEntryDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    return '$weekday\n${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final mood = entry.mood;
    final dateLabel = _formatEntryDate(entry.loggedAt);

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: playTapAnimation,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _hoverController]),
          builder: (context, _) {
            final hoverScale = 1.0 + 0.07 * _hover.value;
            final hoverLift = -8.0 * _hover.value;
            final shadowBlur = 10.0 + 14.0 * _hover.value;
            final shadowOffset = 4.0 + 6.0 * _hover.value;
            final accentAlpha = 0.22 + 0.18 * _hover.value;

            return Transform.translate(
              offset: Offset(0, hoverLift),
              child: Transform.scale(
                scale: hoverScale * _tapScale.value,
                child: Transform.rotate(
                  angle: _wiggle.value,
                  child: Container(
                    width: 92,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        left: BorderSide(
                          color: mood.accent,
                          width: 5 + 2 * _hover.value,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mood.accent.withValues(alpha: accentAlpha),
                          blurRadius: shadowBlur,
                          offset: Offset(0, shadowOffset),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.25,
                              fontWeight: FontWeight.w600,
                              color: mood.stroke.withValues(
                                alpha: 0.85 + 0.1 * _hover.value,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          MoodFace(
                            key: _faceKey,
                            mood: mood,
                            size: widget.faceSize,
                            strokeWidth: 2.2,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 28 + 10 * _hover.value,
                            height: 4 + 1 * _hover.value,
                            decoration: BoxDecoration(
                              color: mood.accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
