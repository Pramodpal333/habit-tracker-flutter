import 'package:flutter/material.dart';

/// How important a habit is — stored on [Habit] and used for sorting/UI later.
enum HabitPriority {
  low,
  medium,
  high;

  String get label => switch (this) {
        HabitPriority.low => 'Low',
        HabitPriority.medium => 'Medium',
        HabitPriority.high => 'High',
      };

  IconData get icon => switch (this) {
        HabitPriority.low => Icons.south_rounded,
        HabitPriority.medium => Icons.drag_handle_rounded,
        HabitPriority.high => Icons.north_rounded,
      };

  /// Accent for selected priority chip (matches severity at a glance).
  Color get accentColor => switch (this) {
        HabitPriority.low => const Color(0xFF5CB8A5),
        HabitPriority.medium => const Color(0xFFF5A623),
        HabitPriority.high => const Color(0xFFE85D5D),
      };

  static HabitPriority fromStorage(String? value) {
    return HabitPriority.values.firstWhere(
      (p) => p.name == value,
      orElse: () => HabitPriority.medium,
    );
  }
}
