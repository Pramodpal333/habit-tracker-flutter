import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/habit_repository.dart';
import '../../models/habit_model.dart';
import 'habit_event.dart';
import 'habit_state.dart';

/// BLoC to handle habit-related business logic.
///
/// Persistence goes through [HabitRepository] so this class never imports
/// Hive or network code — swap the repository in [main] when you add a backend.
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _repository;

  HabitBloc({required HabitRepository repository})
      : _repository = repository,
        super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ClearAllHabits>(_onClearAllHabits);
    on<ToggleHabitStatus>(_onToggleHabitStatus);
    on<ToggleHabitStatusByDate>(_onToggleHabitStatusByDate);
  }

  Future<void> _onLoadHabits(
    LoadHabits event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final habits = await _repository.getHabits();
      emit(state.copyWith(habits: habits, isLoading: false));
    } catch (_) {
      // Keep UI usable; user can retry by restarting the app.
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateHabit(
    UpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    final title = event.title.trim();
    if (title.isEmpty) return;

    Habit? updatedHabit;
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == event.id) {
        updatedHabit = habit.copyWith(title: title);
        return updatedHabit!;
      }
      return habit;
    }).toList();

    if (updatedHabit == null) return;

    emit(state.copyWith(habits: updatedHabits));
    await _repository.saveHabit(updatedHabit!);
  }

  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    final updatedHabits =
        state.habits.where((h) => h.id != event.id).toList();
    emit(state.copyWith(habits: updatedHabits));
    await _repository.deleteHabit(event.id);
  }

  Future<void> _onClearAllHabits(
    ClearAllHabits event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(habits: []));
    await _repository.clearAllHabits();
  }

  Future<void> _onAddHabit(AddHabit event, Emitter<HabitState> emit) async {
    if (event.title.trim().isEmpty) return;

    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      createdAt: DateTime.now(),
      priority: event.priority,
    );

    final updatedHabits = List<Habit>.from(state.habits)..add(newHabit);
    emit(state.copyWith(habits: updatedHabits));

    await _repository.saveHabit(newHabit);
  }

  Future<void> _onToggleHabitStatus(
    ToggleHabitStatus event,
    Emitter<HabitState> emit,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    Habit? updatedHabit;
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == event.id) {
        final List<DateTime> newDates = List.from(habit.completedDates);
        final bool isCurrentlyDone = habit.isDoneToday;

        if (isCurrentlyDone) {
          newDates.removeWhere((d) =>
              d.year == today.year &&
              d.month == today.month &&
              d.day == today.day);
        } else {
          newDates.add(today);
        }

        updatedHabit = habit.copyWith(completedDates: newDates);
        return updatedHabit!;
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));

    if (updatedHabit != null) {
      await _repository.saveHabit(updatedHabit!);
    }
  }

  Future<void> _onToggleHabitStatusByDate(
    ToggleHabitStatusByDate event,
    Emitter<HabitState> emit,
  ) async {
    final targetDate =
        DateTime(event.date.year, event.date.month, event.date.day);

    Habit? updatedHabit;
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == event.id) {
        final List<DateTime> newDates = List.from(habit.completedDates);
        final isCurrentlyDone = habit.completedDates.any((d) =>
            d.year == targetDate.year &&
            d.month == targetDate.month &&
            d.day == targetDate.day);

        if (isCurrentlyDone) {
          newDates.removeWhere((d) =>
              d.year == targetDate.year &&
              d.month == targetDate.month &&
              d.day == targetDate.day);
        } else {
          newDates.add(targetDate);
        }
        updatedHabit = habit.copyWith(completedDates: newDates);
        return updatedHabit!;
      }
      return habit;
    }).toList();

    emit(state.copyWith(habits: updatedHabits));

    if (updatedHabit != null) {
      await _repository.saveHabit(updatedHabit!);
    }
  }
}
