import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../blocs/habit/habit_state.dart';
import '../core/storage_permissions.dart';
import '../widgets/habit_card.dart';
import '../widgets/habits_empty_state.dart';
import 'habit_details_screen.dart';

/// **Home** tab — daily checklist with streak toggle (see [HabitCard]).
///
/// Requests storage access once here so Settings backup/import works on older
/// Android devices (see [StoragePermissions]).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoragePermissions.requestOnAppStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state.isLoading && state.habits.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.habits.isEmpty) {
            return const HabitsEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
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
                      builder: (context) =>
                          HabitDetailsScreen(habitId: habit.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
