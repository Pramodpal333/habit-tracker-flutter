import 'package:equatable/equatable.dart';
import '../../models/habit_model.dart';

/// Represents the current state of the habits list
class HabitState extends Equatable {
  final List<Habit> habits;

  /// True while the initial load from [HabitRepository] is in progress.
  final bool isLoading;

  const HabitState({
    this.habits = const [],
    this.isLoading = false,
  });

  HabitState copyWith({
    List<Habit>? habits,
    bool? isLoading,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [habits, isLoading];
}
