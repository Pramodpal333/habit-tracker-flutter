import 'package:flutter/material.dart';

import '../models/habit_priority.dart';
import 'app_colors.dart';

/// Text and icon colors for habit tiles on priority gradients.
///
/// Completed state uses **dark, priority-tinted** colors so titles and streak
/// icons stay readable on green / amber / rose tile backgrounds (gray
/// [AppTypography.cardTitleDone] washed out on red, especially).
class HabitTileColors {
  HabitTileColors._();

  static Color title(HabitPriority priority, {required bool isDoneToday}) {
    if (!isDoneToday) {
      return AppColors.textPrimary;
    }

    return switch (priority) {
      HabitPriority.low => const Color(0xFF1A4538),
      HabitPriority.medium => const Color(0xFF5A3F06),
      HabitPriority.high => const Color(0xFF6E1520),
    };
  }

  /// Fire + streak count when today's habit is complete — darker for contrast.
  static Color streakEmphasis(HabitPriority priority) {
    return switch (priority) {
      HabitPriority.low => const Color(0xFF1F5A47),
      HabitPriority.medium => const Color(0xFF7A5208),
      HabitPriority.high => const Color(0xFF8B1E2A),
    };
  }

  /// Fire + streak when not yet done today — softer but still on-brand.
  static Color streakMuted(HabitPriority priority) {
    return streakEmphasis(priority).withValues(alpha: 0.45);
  }
}
