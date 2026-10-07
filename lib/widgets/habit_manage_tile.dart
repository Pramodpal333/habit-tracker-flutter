import 'package:flutter/material.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';
import 'package:smooth_border/smooth_border.dart';
import 'package:habit_checklist/core/utils.dart';

import '../models/habit_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import 'app_list_tile.dart';
import 'habit_manage_action.dart';
import 'habit_manage_menu.dart';

export 'habit_manage_action.dart';

/// List row for the **Habits** tab — management focus, not daily check-off.
///
/// Home uses [HabitCard] with the streak/fire control; this tile intentionally
/// has no toggle so users don't confuse "track today" with "manage habit".
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
      gradient: AppGradients.habitTileGradient(habit.priority, habit.id),
      shadowTint: habit.priority.accentColor,
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(habit.title.toTitleCase(), style: AppTypography.cardTitle),
          const SizedBox(height: 4),
          Text(
            'Current streak: $streak day${streak == 1 ? '' : 's'}',
            style: AppTypography.emptyStateText.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      trailing: Builder(
        builder: (buttonContext) {
          return Material(
            color: Colors.transparent,
            shape: SmoothRectangleBorder(borderRadius: 14, smoothing: 0.8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showHabitManageMenu(
                context,
                anchorContext: buttonContext,
              ).then((action) {
                if (action != null) onActionSelected(action);
              }),
              splashColor: AppColors.textPrimary.withValues(alpha: 0.08),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
