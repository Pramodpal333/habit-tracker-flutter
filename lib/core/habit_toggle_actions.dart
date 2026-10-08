import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_collection/business/habit_tracker/streak_counter.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import 'utils.dart';
import '../models/habit_model.dart';
import '../widgets/app_alert_sheet.dart';

/// Toggles completion for [date]. Completing is immediate; undoing asks for confirmation.
Future<void> toggleHabitCompletionForDate(
  BuildContext context, {
  required Habit habit,
  required DateTime date,
  void Function(int streakCount, List<DateTime> completedDates, DateTime day)?
      onMarkedComplete,
}) async {
  final day = DateTime(date.year, date.month, date.day);
  final wasDone = habit.isCompletedOn(day);

  if (!wasDone) {
    context.read<HabitBloc>().add(ToggleHabitStatusByDate(habit.id, day));
    final updatedDates = [...habit.completedDates, day];
    onMarkedComplete?.call(
      StreakCounter(completedDates: updatedDates).currentStreak,
      updatedDates,
      day,
    );
    return;
  }

  final confirmed = await showAppConfirmSheet(
    context,
    title: 'Undo completion?',
    message:
        'Mark "${habit.title.toTitleCase()}" as incomplete for this day? '
        'Your streak for this habit may change.',
    tone: AppAlertTone.warning,
    confirmLabel: 'Yes, undo',
    cancelLabel: 'Keep completed',
    icon: Icons.undo_rounded,
  );

  if (confirmed == true && context.mounted) {
    context.read<HabitBloc>().add(ToggleHabitStatusByDate(habit.id, day));
  }
}
