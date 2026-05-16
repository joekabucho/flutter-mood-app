import 'package:flutter/material.dart';

import '../models/mood.dart';
import 'mood_face.dart';

class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.onMoodSelected,
  });

  final ValueChanged<Mood> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Mood.values.map((mood) {
        return _MoodTapTarget(
          mood: mood,
          onTap: () => onMoodSelected(mood),
        );
      }).toList(),
    );
  }
}

class _MoodTapTarget extends StatefulWidget {
  const _MoodTapTarget({
    required this.mood,
    required this.onTap,
  });

  final Mood mood;
  final VoidCallback onTap;

  @override
  State<_MoodTapTarget> createState() => _MoodTapTargetState();
}

class _MoodTapTargetState extends State<_MoodTapTarget>
    with TickerProviderStateMixin {
  final GlobalKey<MoodFaceState> _faceKey = GlobalKey<MoodFaceState>();

  late final AnimationController _pressController;
  late final AnimationController _hoverController;
  late final Animation<double> _pressScale;
  late final Animation<double> _hover;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _pressScale = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
    _hover = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
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

  Future<void> _handleTap() async {
    await _pressController.forward();
    await _faceKey.currentState?.playReaction();
    widget.onTap();
    await _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget.mood;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pressController, _hoverController]),
          builder: (context, child) {
            final hoverScale = 1.0 + 0.06 * _hover.value;
            final hoverLift = -6.0 * _hover.value;

            return Transform.translate(
              offset: Offset(0, hoverLift),
              child: Transform.scale(
                scale: hoverScale * _pressScale.value,
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Ink(
              width: 108,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: mood.accent.withValues(
                  alpha: 0.18 + 0.1 * _hover.value,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: mood.accent.withValues(
                    alpha: 0.55 + 0.25 * _hover.value,
                  ),
                  width: 2 + _hover.value,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mood.accent.withValues(alpha: 0.12 * _hover.value),
                    blurRadius: 16 * _hover.value,
                    offset: Offset(0, 6 * _hover.value),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MoodFace(
                    key: _faceKey,
                    mood: mood,
                    size: 76,
                    strokeWidth: 2.6,
                    idleBlink: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mood.stroke,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
