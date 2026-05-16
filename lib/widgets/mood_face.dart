import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/mood.dart';
import '../painters/mood_face_painter.dart';

class MoodFace extends StatefulWidget {
  const MoodFace({
    super.key,
    required this.mood,
    this.size = 72,
    this.strokeWidth = 2.4,
    this.idleBlink = false,
  });

  final Mood mood;
  final double size;
  final double strokeWidth;

  /// Periodically blinks when true (used on picker faces).
  final bool idleBlink;

  @override
  MoodFaceState createState() => MoodFaceState();
}

class MoodFaceState extends State<MoodFace> with TickerProviderStateMixin {
  late final AnimationController _reactionController;
  late final AnimationController _blinkController;
  late final AnimationController _hoverController;
  late final Animation<double> _reaction;
  late final Animation<double> _blink;
  late final Animation<double> _hover;

  Timer? _idleBlinkTimer;

  @override
  void initState() {
    super.initState();
    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _blink = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    _hover = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    if (widget.idleBlink) {
      _scheduleIdleBlink();
    }
  }

  @override
  void didUpdateWidget(covariant MoodFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.idleBlink && !oldWidget.idleBlink) {
      _scheduleIdleBlink();
    } else if (!widget.idleBlink && oldWidget.idleBlink) {
      _idleBlinkTimer?.cancel();
      _idleBlinkTimer = null;
    }
  }

  @override
  void dispose() {
    _idleBlinkTimer?.cancel();
    _reactionController.dispose();
    _blinkController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  /// Gently morphs the drawn expression while a parent card is hovered.
  void setHovered(bool hovered) {
    if (hovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _scheduleIdleBlink() {
    _idleBlinkTimer?.cancel();
    _idleBlinkTimer = Timer(
      Duration(milliseconds: 2800 + math.Random().nextInt(2200)),
      () async {
        if (!mounted || !widget.idleBlink) return;
        await _blinkOnce();
        _scheduleIdleBlink();
      },
    );
  }

  Future<void> _blinkOnce() async {
    if (!mounted) return;
    await _blinkController.forward();
    if (!mounted) return;
    await _blinkController.reverse();
  }

  /// Plays a brief drawn expression animation (blink + mood-specific motion).
  Future<void> playReaction() async {
    if (!mounted) return;
    await Future.wait([
      _blinkOnce(),
      _reactionController.forward(from: 0).then((_) {
        if (mounted) _reactionController.reverse();
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_reaction, _blink, _hover]),
      builder: (context, _) {
        final reaction =
            math.min(1.0, _reaction.value + _hover.value * 0.42);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: MoodFacePainter(
              mood: widget.mood,
              strokeWidth: widget.strokeWidth,
              blink: _blink.value,
              reaction: reaction,
            ),
          ),
        );
      },
    );
  }
}
