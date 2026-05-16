import 'package:flutter/material.dart';

enum Mood {
  happy,
  neutral,
  sad;

  String get label => switch (this) {
        Mood.happy => 'Happy',
        Mood.neutral => 'Neutral',
        Mood.sad => 'Sad',
      };

  Color get accent => switch (this) {
        Mood.happy => const Color(0xFFFFB74D),
        Mood.neutral => const Color(0xFF90A4AE),
        Mood.sad => const Color(0xFF7986CB),
      };

  Color get faceFill => switch (this) {
        Mood.happy => const Color(0xFFFFF176),
        Mood.neutral => const Color(0xFFECEFF1),
        Mood.sad => const Color(0xFFB3E5FC),
      };

  Color get stroke => switch (this) {
        Mood.happy => const Color(0xFFF57F17),
        Mood.neutral => const Color(0xFF546E7A),
        Mood.sad => const Color(0xFF3949AB),
      };
}
