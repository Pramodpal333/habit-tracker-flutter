import 'package:flutter/material.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';
import 'package:habit_checklist/core/utils.dart';

import '../models/habit_model.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import '../theme/habit_tile_colors.dart';
import 'app_list_tile.dart';

/// A beautifully styled card widget to display a single habit.
/// Features a circular rectangle design (rounded corners) as requested.
class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final streakCounter = StreakCounter(completedDates: habit.completedDates);
    final currentStreak = streakCounter.currentStreak;
    final isDone = habit.isDoneToday;
    final priority = habit.priority;
    final tileGradient = AppGradients.habitTileGradient(priority, habit.id);
    final titleColor =
        HabitTileColors.title(priority, isDoneToday: isDone);
    final streakColor = isDone
        ? HabitTileColors.streakEmphasis(priority)
        : HabitTileColors.streakMuted(priority);

    return GestureDetector(
      onLongPress: onTap,
      child: AppListTile(
        gradient: tileGradient,
        shadowTint: priority.accentColor,
        onTap: onToggle,
        trailing: GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: streakColor,
                  size: 28,
                ),
                const SizedBox(height: 2),
                Text(
                  '$currentStreak',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: streakColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Text(
          habit.title.toTitleCase(),
          style: AppTypography.cardTitle.copyWith(
            color: titleColor,
            decoration: isDone ? TextDecoration.lineThrough : null,
            decorationColor: titleColor,
          ),
        ),
      ),
    );
  }
}
