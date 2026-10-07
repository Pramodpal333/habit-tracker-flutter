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

  /// Soft fill for selected priority chips on add-habit sheet.
  LinearGradient get chipGradient => switch (this) {
        HabitPriority.low => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7FBFA8), Color(0xFFA8D9C6)],
          ),
        HabitPriority.medium => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8B85C), Color(0xFFF0CC7A)],
          ),
        HabitPriority.high => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8878F), Color(0xFFF0A3AA)],
          ),
      };

  static HabitPriority fromStorage(String? value) {
    return HabitPriority.values.firstWhere(
      (p) => p.name == value,
      orElse: () => HabitPriority.medium,
    );
  }
}
