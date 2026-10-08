import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Last 7 days ending on [anchorDate]: filled dot if complete, outline if not.
class HabitWeekProgress extends StatelessWidget {
  final List<DateTime> completedDates;
  final DateTime anchorDate;

  const HabitWeekProgress({
    super.key,
    required this.completedDates,
    required this.anchorDate,
  });

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isCompletedOn(DateTime day) {
    return completedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  List<DateTime> get _days {
    final end = _dateOnly(anchorDate);
    return List.generate(7, (i) => end.subtract(Duration(days: 6 - i)));
  }

  @override
  Widget build(BuildContext context) {
    final dayLabels = _days.map((d) => DateFormat('E').format(d)).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final day = _days[index];
          final done = _isCompletedOn(day);
          final isAnchor = day == _dateOnly(anchorDate);

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayLabels[index].substring(0, 1).toUpperCase(),
                  style: AppTypography.emptyStateText.copyWith(
                    fontSize: 12,
                    fontWeight: isAnchor ? FontWeight.w700 : FontWeight.w500,
                    color: isAnchor
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 8),
                _DayProgressDot(filled: done, emphasized: isAnchor),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DayProgressDot extends StatelessWidget {
  final bool filled;
  final bool emphasized;

  const _DayProgressDot({required this.filled, required this.emphasized});

  static const double _size = 38;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: emphasized ? _size + 2 : _size,
        height: emphasized ? _size + 2 : _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF66DE93), Color(0xFF5CB8A5)],
          ),
          boxShadow: [
            if (emphasized)
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.45),
                blurRadius: 10,
                spreadRadius: 1,
              ),
          ],
        ),
        child: emphasized
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : null,
      );
    }

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: emphasized
              ? AppColors.primary.withValues(alpha: 0.55)
              : AppColors.borderInactive,
          width: emphasized ? 1.2 : 0.2,
        ),
        color: AppColors.cardSurface.withValues(alpha: 0.01),
      ),
    );
  }
}
