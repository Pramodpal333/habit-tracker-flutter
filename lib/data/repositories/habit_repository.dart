import '../../models/habit_model.dart';

/// Contract for where habit data lives (phone, API, Firebase, etc.).
///
/// The UI and [HabitBloc] depend on this interface only — not on Hive or HTTP.
/// To add cloud sync later:
/// 1. Implement [HabitRepository] again (e.g. `RemoteHabitRepository`).
/// 2. Optionally wrap local + remote in a `SyncHabitRepository` that implements
///    the same methods and chooses read/write strategy.
/// 3. Inject the new implementation in [main.dart]; no bloc/screen changes needed.
abstract class HabitRepository {
  /// Returns every saved habit, or an empty list if none exist yet.
  Future<List<Habit>> getHabits();

  /// Inserts a new habit or replaces an existing one with the same [Habit.id].
  Future<void> saveHabit(Habit habit);

  /// Removes a single habit by id (used from the Habits tab menu).
  Future<void> deleteHabit(String id);

  /// Wipes all habits — used by Settings → Reset app, keeps settings keys separate.
  Future<void> clearAllHabits();

  /// Replaces the full habit list — used when restoring a backup file.
  Future<void> replaceAllHabits(List<Habit> habits);
}
