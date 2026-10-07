import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_border/smooth_border.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../blocs/habit/habit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'habit_details_screen.dart';

/// The main dashboard where users can see their list of habits.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.isLoading && state.habits.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist_rtl_rounded,
                    size: 80,
                    color: AppColors.borderInactive,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No habits added yet.\nStart by adding a new one!',
                    textAlign: TextAlign.center,
                    style: AppTypography.emptyStateText,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: state.habits.length,
            itemBuilder: (context, index) {
              final habit = state.habits[index];
              return HabitCard(
                habit: habit,
                onToggle: () {
                  context.read<HabitBloc>().add(ToggleHabitStatus(habit.id));
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitDetailsScreen(habitId: habit.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add habit screen
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.cardSurface,
            shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
            builder: (context) => const AddHabitScreen(),
          );
        },
        shape: SmoothRectangleBorder(borderRadius: 30, smoothing: 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
