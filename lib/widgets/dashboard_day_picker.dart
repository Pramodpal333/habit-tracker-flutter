import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_border/smooth_border.dart';

import '../core/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Horizontal day picker for the dashboard — only past days and today.
class DashboardDayPicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DashboardDayPicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<DashboardDayPicker> createState() => _DashboardDayPickerState();
}

class _DashboardDayPickerState extends State<DashboardDayPicker> {
  static const _lookbackDays = 90;

  late final DateTime _today;
  late final DateTime _timelineStart;
  late final DatePickerController _controller;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _timelineStart = _today.subtract(const Duration(days: _lookbackDays - 1));
    _controller = DatePickerController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToSelection();
    });
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String get _headlineLabel {
    final selected = _dateOnly(widget.selectedDate);
    if (_isSameDay(selected, _today)) return 'Today';
    if (_isSameDay(selected, _today.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return DateFormat('EEEE').format(selected);
  }

  String get _subtitleLabel =>
      DateFormat('MMMM d, yyyy').format(_dateOnly(widget.selectedDate));

  void _goToToday() {
    if (_isSameDay(widget.selectedDate, _today)) {
      _controller.animateToSelection(curve: Curves.easeOutCubic);
      return;
    }
    widget.onDateChanged(_today);
  }

  void _syncPickerToSelectedDate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.setDateAndAnimate(
        _dateOnly(widget.selectedDate),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(DashboardDayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      _syncPickerToSelectedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.screenTitle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: AppColors.textSecondary,
    );
    final dayNumberStyle = AppTypography.screenTitle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    );

    final showTodayChip = !_isSameDay(widget.selectedDate, _today);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headlineLabel,
                      style: AppTypography.screenTitle.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitleLabel,
                      style: AppTypography.emptyStateText.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (showTodayChip)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: AppHaptics.wrapButton(_goToToday)!,
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: SmoothRectangleBorder(
                          borderRadius: 20,
                          smoothing: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          'Today',
                          style: AppTypography.screenTitle.copyWith(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF8F6FF)],
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              shape: SmoothRectangleBorder(
                borderRadius: 24,
                smoothing: 1,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.history_rounded,
                //         size: 16,
                //         color: AppColors.primary.withValues(alpha: 0.85),
                //       ),
                //       const SizedBox(width: 6),
                //       Text(
                //         'Pick a past day to review habits',
                //         style: labelStyle,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6,
                  ),
                  child: SizedBox(
                    height: 92,
                    child: DatePicker(
                      _timelineStart,
                      controller: _controller,
                      daysCount: _lookbackDays,
                      initialSelectedDate: _dateOnly(widget.selectedDate),
                      height: 92,
                      width: 54,
                      selectionColor: AppColors.primary,
                      selectedTextColor: AppColors.textLight,
                      deactivatedColor: AppColors.borderInactive,
                      monthTextStyle: labelStyle.copyWith(fontSize: 10),
                      dayTextStyle: labelStyle.copyWith(fontSize: 10),
                      dateTextStyle: dayNumberStyle,
                      onDateChange: (date) {
                        final picked = _dateOnly(date);
                        if (picked.isAfter(_today)) return;
                        widget.onDateChanged(picked);
                      },
                    ),
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
