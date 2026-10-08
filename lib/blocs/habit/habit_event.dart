import 'package:equatable/equatable.dart';

import '../../models/habit_priority.dart';

/// Base event class for Habit-related actions
abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

/// Loads habits from [HabitRepository] when the app starts (or after refresh).
class LoadHabits extends HabitEvent {
  const LoadHabits();
}

/// Updates title and priority (Habits tab → Edit).
class UpdateHabit extends HabitEvent {
  final String id;
  final String title;
  final HabitPriority priority;

  const UpdateHabit({
    required this.id,
    required this.title,
    required this.priority,
  });

  @override
  List<Object?> get props => [id, title, priority];
}

/// Removes one habit from storage and state.
class DeleteHabit extends HabitEvent {
  final String id;

  const DeleteHabit(this.id);

  @override
  List<Object?> get props => [id];
}

/// Clears every habit — Settings → Reset app (after user confirmation).
class ClearAllHabits extends HabitEvent {
  const ClearAllHabits();
}

/// Event to add a new habit
class AddHabit extends HabitEvent {
  final String title;
  final HabitPriority priority;

  const AddHabit(this.title, {this.priority = HabitPriority.medium});

  @override
  List<Object?> get props => [title, priority];
}

/// Event to toggle the completion status of a habit (for today)
class ToggleHabitStatus extends HabitEvent {
  final String id;

  const ToggleHabitStatus(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to toggle the completion status of a habit for a specific date
class ToggleHabitStatusByDate extends HabitEvent {
  final String id;
  final DateTime date;

  const ToggleHabitStatusByDate(this.id, this.date);

  @override
  List<Object?> get props => [id, date];
}
