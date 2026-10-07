import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../models/habit_priority.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Three mutually exclusive priority chips styled like radio buttons.
///
/// Used on add/edit flows; keeps selection UI separate from [HabitBloc] so
/// the same control can be reused without duplicating layout code.
class HabitPrioritySelector extends StatelessWidget {
  final HabitPriority value;
  final ValueChanged<HabitPriority> onChanged;

  const HabitPrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: AppTypography.cardTitle.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: HabitPriority.values.map((priority) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: priority != HabitPriority.high ? 8 : 0,
                ),
                child: _PriorityRadioChip(
                  priority: priority,
                  selected: value == priority,
                  onTap: () => onChanged(priority),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PriorityRadioChip extends StatelessWidget {
  final HabitPriority priority;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityRadioChip({
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = priority.accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accent.withValues(alpha: 0.15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: ShapeDecoration(
            color: selected
                ? accent.withValues(alpha: 0.14)
                : AppColors.background,
            shape: SmoothRectangleBorder(
              borderRadius: 18,
              smoothing: 0.9,
              side: BorderSide(
                color: selected ? accent : AppColors.borderInactive,
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? accent : AppColors.textSecondary,
                    width: 2,
                  ),
                  color: selected ? accent : Colors.transparent,
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Icon(
                priority.icon,
                size: 20,
                color: selected ? accent : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                priority.label,
                style: AppTypography.emptyStateText.copyWith(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
