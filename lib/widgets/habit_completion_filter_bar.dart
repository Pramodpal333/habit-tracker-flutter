import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../core/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Which habits to show on the home checklist for the [DashboardDayPicker] date.
enum HabitCompletionFilter {
  /// Every habit that existed on the selected day (default).
  all,

  /// Habits marked complete on the selected day.
  completed,

  /// Habits not yet marked complete on the selected day.
  incomplete,
}

/// Filter controls for the home habit list — completed vs incomplete for the
/// currently selected calendar day.
class HabitCompletionFilterBar extends StatelessWidget {
  final HabitCompletionFilter value;
  final ValueChanged<HabitCompletionFilter> onChanged;

  const HabitCompletionFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _select(HabitCompletionFilter next) {
    // Tapping the active chip again clears the filter and shows all habits.
    onChanged(value == next ? HabitCompletionFilter.all : next);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            size: 20,
            color: AppColors.textSecondary.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 8),
          Text(
            'Filter',
            style: AppTypography.emptyStateText.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _FilterChip(
                    label: 'Completed',
                    selected: value == HabitCompletionFilter.completed,
                    onTap: () => _select(HabitCompletionFilter.completed),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterChip(
                    label: 'Incomplete',
                    selected: value == HabitCompletionFilter.incomplete,
                    onTap: () => _select(HabitCompletionFilter.incomplete),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: AppHaptics.wrapButton(onTap)!,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: ShapeDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.18)
                : AppColors.cardSurface,
            shape: SmoothRectangleBorder(
              borderRadius: 16,
              smoothing: 1,
              side: BorderSide(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.45)
                    : AppColors.borderInactive,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.screenTitle.copyWith(
              fontSize: 13,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
