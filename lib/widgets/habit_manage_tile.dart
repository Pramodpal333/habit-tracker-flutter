import 'package:flutter/material.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';
import 'package:habit_checklist/core/utils.dart';

import '../models/habit_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_list_tile.dart';

/// List row for the **Habits** tab — management focus, not daily check-off.
///
/// Home uses [HabitCard] with the streak/fire control; this tile intentionally
/// has no toggle so users don't confuse "track today" with "manage habit".
enum HabitManageAction {
  seeAnalytics,
  editHabit,
  deleteHabit,
}

class HabitManageTile extends StatelessWidget {
  final Habit habit;
  final ValueChanged<HabitManageAction> onActionSelected;

  const HabitManageTile({
    super.key,
    required this.habit,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final streak = StreakCounter(completedDates: habit.completedDates)
        .currentStreak;

    return AppListTile(
      // No row-level tap — actions live in the ⋮ menu only.
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            habit.title.toTitleCase(),
            style: AppTypography.cardTitle,
          ),
          const SizedBox(height: 4),
          Text(
            'Current streak: $streak day${streak == 1 ? '' : 's'}',
            style: AppTypography.emptyStateText.copyWith(fontSize: 13),
          ),
        ],
      ),
      trailing: PopupMenuButton<HabitManageAction>(
        onSelected: onActionSelected,
        icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textPrimary),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: HabitManageAction.seeAnalytics,
            child: _menuRow(
              Icons.analytics_outlined,
              'See analytics',
            ),
          ),
          PopupMenuItem(
            value: HabitManageAction.editHabit,
            child: _menuRow(Icons.edit_rounded, 'Edit habit'),
          ),
          PopupMenuItem(
            value: HabitManageAction.deleteHabit,
            child: _menuRow(
              Icons.delete_rounded,
              'Delete habit',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuRow(IconData icon, String label, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color ?? AppColors.textPrimary),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
