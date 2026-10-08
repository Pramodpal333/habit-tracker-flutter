import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/habit/habit_bloc.dart';
import '../core/habit_toggle_actions.dart';
import '../blocs/habit/habit_state.dart';
import '../core/storage_permissions.dart';
import '../models/habit_model.dart';
import '../widgets/dashboard_day_picker.dart';
import '../widgets/habit_card.dart';
import '../widgets/habits_empty_state.dart';
import 'habit_completed_screen.dart';
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
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoragePermissions.requestOnAppStart();
    });
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<Habit> _habitsForSelectedDay(List<Habit> habits) {
    return habits
        .where((habit) => !_dateOnly(habit.createdAt).isAfter(_selectedDate))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardDayPicker(
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() => _selectedDate = _dateOnly(date));
              },
            ),
            Expanded(
              child: BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state.isLoading && state.habits.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.habits.isEmpty) {
                    return const HabitsEmptyState();
                  }

                  final habitsForDay = _habitsForSelectedDay(state.habits);

                  if (habitsForDay.isEmpty) {
                    return const HabitsEmptyState(
                      message:
                          'No habits existed on this day.\nTry another date.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    itemCount: habitsForDay.length,
                    itemBuilder: (context, index) {
                      final habit = habitsForDay[index];
                      return HabitCard(
                        habit: habit,
                        viewDate: _selectedDate,
                        onToggle: () {
                          toggleHabitCompletionForDate(
                            context,
                            habit: habit,
                            date: _selectedDate,
                            onMarkedComplete: (streak) {
                              HabitCompletedScreen.show(
                                context,
                                habitId: habit.id,
                                streakCount: streak,
                              );
                            },
                          );
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
            ),
          ],
        ),
      ),
    );
  }
}
