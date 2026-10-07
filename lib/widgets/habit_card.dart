import 'package:flutter/material.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';
import 'package:habit_checklist/core/utils.dart';

import '../models/habit_model.dart';
import '../theme/app_typography.dart';
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

    return GestureDetector(
      onLongPress: onTap,
      child: AppListTile(
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
                  color: isDone
                      ? const Color(0xFFE53935)
                      : Colors.grey.shade400,
                  size: 28,
                ),
                const SizedBox(height: 2),
                Text(
                  '$currentStreak',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDone
                        ? const Color(0xFFE53935)
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Text(
          habit.title.toTitleCase(),
          style: isDone ? AppTypography.cardTitleDone : AppTypography.cardTitle,
        ),
      ),
    );
  }
}
