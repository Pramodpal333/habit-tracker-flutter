import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_border/smooth_border.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../blocs/habit/habit_state.dart';
import '../models/habit_priority.dart';
import '../theme/app_colors.dart';
import '../widgets/app_alert_sheet.dart';
import '../widgets/habit_manage_tile.dart';
import '../widgets/habits_empty_state.dart';
import 'edit_habit_screen.dart';
import 'habit_details_screen.dart';

/// **Habits** tab — browse and manage habits without marking them complete.
///
/// Daily tracking stays on [HomeScreen]; this screen is for analytics entry,
/// rename, and delete so each tab has a single clear purpose.
class HabitsManagementScreen extends StatelessWidget {
  const HabitsManagementScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, String habitId) async {
    final confirmed = await showAppConfirmSheet(
      context,
      title: 'Delete habit?',
      message:
          'This removes the habit and all of its completion history. '
          'This cannot be undone.',
      tone: AppAlertTone.destructive,
      confirmLabel: 'Delete habit',
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed == true && context.mounted) {
      context.read<HabitBloc>().add(DeleteHabit(habitId));
    }
  }

  void _openEditSheet(
    BuildContext context,
    String id,
    String title,
    HabitPriority priority,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
      builder: (context) => EditHabitScreen(
        habitId: id,
        initialTitle: title,
        initialPriority: priority,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Habits')),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.isLoading && state.habits.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.habits.isEmpty) {
            return const HabitsEmptyState(
              message:
                  'No habits yet.\nAdd one from the Home tab, then manage it here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: state.habits.length,
            itemBuilder: (context, index) {
              final habit = state.habits[index];
              return HabitManageTile(
                habit: habit,
                onActionSelected: (action) {
                  switch (action) {
                    case HabitManageAction.seeAnalytics:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HabitDetailsScreen(habitId: habit.id),
                        ),
                      );
                    case HabitManageAction.editHabit:
                      _openEditSheet(
                        context,
                        habit.id,
                        habit.title,
                        habit.priority,
                      );
                    case HabitManageAction.deleteHabit:
                      _confirmDelete(context, habit.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
