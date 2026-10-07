import 'package:flutter/material.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/habit_stats.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';
import 'package:flutter_calendar_collection/core/utils/date_utils.dart';
import 'package:flutter_calendar_collection/l10n/app_localizations.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'smooth_container.dart';

/// A reusable calendar and stats widget that shows current/longest streaks,
/// a monthly completion rate, a weekly overview, and an interactive month grid.
class HabitStatsCalendar extends StatefulWidget {
  final List<DateTime> completedDates;
  final ValueChanged<DateTime>? onDateToggled;

  const HabitStatsCalendar({
    super.key,
    required this.completedDates,
    this.onDateToggled,
  });

  @override
  State<HabitStatsCalendar> createState() => _HabitStatsCalendarState();
}

class _HabitStatsCalendarState extends State<HabitStatsCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _changeMonth(int delta) {
    if (delta > 0 && !_canGoToNextMonth) return;

    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
    });
  }

  /// True when the user may open a month after [_currentMonth] (never past today).
  bool get _canGoToNextMonth {
    final now = DateTime.now();
    final viewedYearMonth = _currentMonth.year * 12 + _currentMonth.month;
    final currentYearMonth = now.year * 12 + now.month;
    return viewedYearMonth < currentYearMonth;
  }

  @override
  Widget build(BuildContext context) {
    // Generate StreakCounter from our BLoC state dates
    final streakCounter = StreakCounter(completedDates: widget.completedDates);
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return Column(
      children: [
        // The pre-built stats from flutter_calendar_collection
        HabitStats(streakCounter: streakCounter, month: _currentMonth),
        const SizedBox(height: 16),

        SmoothContainer(
          color: AppColors.cardSurface,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMonthHeader(),
              const SizedBox(height: 16),
              _buildWeekdayHeader(),
              const SizedBox(height: 8),
              _buildCalendarGrid(gridDays, streakCounter),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
        ),
        Text(
          '${_currentMonth.year} - ${getMonthName(_currentMonth.month)}',
          style: AppTypography.screenTitle.copyWith(fontSize: 18),
        ),
        IconButton(
          onPressed: _canGoToNextMonth ? () => _changeMonth(1) : null,
          icon: Icon(
            Icons.chevron_right,
            color: _canGoToNextMonth
                ? AppColors.textPrimary
                : AppColors.borderInactive,
          ),
        ),
      ],
    );
  }

  String getMonthName(int month) {
    final monthNames = AppLocalizations.of(context).monthNames;
    return monthNames[month];
  }

  Widget _buildWeekdayHeader() {
    return Row(
      children: List.generate(7, (index) {
        final weekday = (index + 1) % 7 == 0 ? 7 : (index + 1);
        return Expanded(
          child: Center(
            child: Text(
              AppLocalizations.of(context).weekdayShort(weekday),
              style: AppTypography.emptyStateText.copyWith(fontSize: 12),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(
    List<DateTime> gridDays,
    StreakCounter streakCounter,
  ) {
    final now = DateTime.now();
    final rows = <Widget>[];

    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isToday = CalendarDateUtils.isSameDay(date, now);
            final isFuture = date.isAfter(now);
            final isCompleted = streakCounter.isCompleted(date);

            return Expanded(
              child: GestureDetector(
                onTap:
                    (isCurrentMonth &&
                        !isFuture &&
                        widget.onDateToggled != null)
                    ? () => widget.onDateToggled!(date)
                    : null,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    color: isCompleted
                        ? AppColors.success.withOpacity(0.15)
                        : null,
                    shape: SmoothRectangleBorder(
                      borderRadius: 12,
                      smoothing: 1,
                      side: isToday
                          ? const BorderSide(color: AppColors.primary, width: 2)
                          : BorderSide.none,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !isCurrentMonth
                              ? Colors.grey.shade300
                              : isFuture
                              ? Colors.grey.shade400
                              : isCompleted
                              ? AppColors.success
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (isCompleted && isCurrentMonth)
                        Positioned(
                          bottom: 4,
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.success.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
    return Column(children: rows);
  }
}
