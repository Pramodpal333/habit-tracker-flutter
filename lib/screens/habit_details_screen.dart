import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_state.dart';
import '../core/habit_toggle_actions.dart';
import '../core/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_gradient_scaffold.dart';
import '../widgets/habit_stats_calendar.dart';

class HabitDetailsScreen extends StatelessWidget {
  final String habitId;

  const HabitDetailsScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    return AppGradientScaffold(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            final habit = state.habits.firstWhere(
              (h) => h.id == habitId,
              orElse: () => throw Exception('Habit not found'),
            );
            return Text(
              habit.title,
              style: AppTypography.screenTitle.copyWith(fontSize: 20),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: AppHaptics.wrapButton(() => Navigator.pop(context)),
        ),
      ),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          final habit = state.habits.firstWhere(
            (h) => h.id == habitId,
            orElse: () => throw Exception('Habit not found'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: HabitStatsCalendar(
              completedDates: habit.completedDates,
              onDateToggled: (date) {
                toggleHabitCompletionForDate(
                  context,
                  habit: habit,
                  date: date,
                );
              },
            ),
          );
        },
      ),
      ),
    );
  }
}
