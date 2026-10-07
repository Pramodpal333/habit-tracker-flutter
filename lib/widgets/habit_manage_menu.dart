import 'package:flutter/material.dart';
import 'package:habit_checklist/core/utils.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'habit_manage_action.dart';

/// Habit actions as a bottom sheet — same pattern as [showAppConfirmSheet].
Future<HabitManageAction?> showHabitManageMenu(
  BuildContext context, {
  required String habitTitle,
}) {
  return showModalBottomSheet<HabitManageAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (sheetContext) {
      return HabitManageActionsSheet(
        habitTitle: habitTitle,
        onSelected: (action) => Navigator.pop(sheetContext, action),
      );
    },
  );
}

/// See analytics / edit / delete for one habit (Habits tab ⋮ menu).
class HabitManageActionsSheet extends StatelessWidget {
  final String habitTitle;
  final ValueChanged<HabitManageAction> onSelected;

  const HabitManageActionsSheet({
    super.key,
    required this.habitTitle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFAFBFF), Color(0xFFF4F0FF)],
        ),
        shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
        shadows: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderInactive,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  habitTitle.toTitleCase(),
                  textAlign: TextAlign.center,
                  style: AppTypography.screenTitle.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Choose an action',
                  style: AppTypography.emptyStateText.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              _MenuRow(
                icon: Icons.query_stats_rounded,
                label: 'See analytics',
                iconBackground: AppColors.primary.withValues(alpha: 0.14),
                iconColor: AppColors.primary,
                onTap: () => onSelected(HabitManageAction.seeAnalytics),
              ),
              _MenuRow(
                icon: Icons.edit_note_rounded,
                label: 'Edit habit',
                iconBackground: const Color(0xFFFFE8B0).withValues(alpha: 0.55),
                iconColor: const Color(0xFF8A5E0C),
                onTap: () => onSelected(HabitManageAction.editHabit),
              ),
              _MenuRow(
                icon: Icons.delete_forever_rounded,
                label: 'Delete habit',
                iconBackground: const Color(0xFFFFD4D8),
                iconColor: const Color(0xFF9E2B36),
                labelColor: const Color(0xFF9E2B36),
                onTap: () => onSelected(HabitManageAction.deleteHabit),
              ),
              SizedBox(height: 20 + bottomInset),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBackground;
  final Color iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        shape: SmoothRectangleBorder(borderRadius: 18, smoothing: 0.85),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: iconBackground,
                    shape: SmoothRectangleBorder(
                      borderRadius: 14,
                      smoothing: 0.85,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, size: 22, color: iconColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: labelColor ?? AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
