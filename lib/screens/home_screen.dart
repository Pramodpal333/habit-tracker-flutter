import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/habit/habit_bloc.dart';
import '../core/habit_toggle_actions.dart';
import '../blocs/habit/habit_state.dart';
import '../core/storage_permissions.dart';
import '../models/habit_model.dart';
import '../widgets/dashboard_day_picker.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_completion_filter_bar.dart';
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

  /// Home list filter — defaults to [HabitCompletionFilter.all] so every habit
  /// for the selected day is shown until the user picks Completed or Incomplete.
  HabitCompletionFilter _completionFilter = HabitCompletionFilter.all;

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

  /// Habits that already existed on [_selectedDate] (ignores habits created later).
  List<Habit> _habitsForSelectedDay(List<Habit> habits) {
    return habits
        .where((habit) => !_dateOnly(habit.createdAt).isAfter(_selectedDate))
        .toList();
  }

  /// Applies [_completionFilter] using each habit's completion state on [_selectedDate].
  List<Habit> _applyCompletionFilter(List<Habit> habitsForDay) {
    switch (_completionFilter) {
      case HabitCompletionFilter.all:
        return habitsForDay;
      case HabitCompletionFilter.completed:
        return habitsForDay
            .where((habit) => habit.isCompletedOn(_selectedDate))
            .toList();
      case HabitCompletionFilter.incomplete:
        return habitsForDay
            .where((habit) => !habit.isCompletedOn(_selectedDate))
            .toList();
    }
  }

  String? _emptyMessageForFilter() {
    switch (_completionFilter) {
      case HabitCompletionFilter.all:
        return null;
      case HabitCompletionFilter.completed:
        return 'No completed habits on this day.\nTry another filter or date.';
      case HabitCompletionFilter.incomplete:
        return 'No incomplete habits on this day.\nTry another filter or date.';
    }
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
            HabitCompletionFilterBar(
              value: _completionFilter,
              onChanged: (filter) {
                setState(() => _completionFilter = filter);
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

                  final visibleHabits = _applyCompletionFilter(habitsForDay);

                  if (visibleHabits.isEmpty) {
                    return HabitsEmptyState(
                      message: _emptyMessageForFilter()!,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: visibleHabits.length,
                    itemBuilder: (context, index) {
                      final habit = visibleHabits[index];
                      return HabitCard(
                        habit: habit,
                        viewDate: _selectedDate,
                        onToggle: () {
                          toggleHabitCompletionForDate(
                            context,
                            habit: habit,
                            date: _selectedDate,
                            onMarkedComplete: (streak, completedDates, day) {
                              HabitCompletedScreen.show(
                                context,
                                habitId: habit.id,
                                streakCount: streak,
                                completedDates: completedDates,
                                completedOn: day,
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
