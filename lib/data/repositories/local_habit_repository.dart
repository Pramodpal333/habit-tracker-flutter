import '../../models/habit_model.dart';
import '../local/habit_local_data_source.dart';
import 'habit_repository.dart';

/// [HabitRepository] backed by on-device storage only.
///
/// Maps domain [Habit] objects to/from JSON and delegates raw I/O to
/// [HabitLocalDataSource]. A future `RemoteHabitRepository` would mirror this
/// class but call your API instead of the local data source.
class LocalHabitRepository implements HabitRepository {
  final HabitLocalDataSource _localDataSource;

  LocalHabitRepository(this._localDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    final maps = await _localDataSource.readAllHabitMaps();
    return maps.map(Habit.fromJson).toList();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final habits = await getHabits();
    final existingIndex = habits.indexWhere((h) => h.id == habit.id);

    if (existingIndex >= 0) {
      habits[existingIndex] = habit;
    } else {
      habits.add(habit);
    }

    await _persistAll(habits);
  }

  /// Writes the full list — simple and reliable for a local-first v1.
  /// A sync layer can later diff or upsert per habit when talking to an API.
  @override
  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await _persistAll(habits);
  }

  @override
  Future<void> clearAllHabits() async {
    await _localDataSource.writeAllHabitMaps([]);
  }

  @override
  Future<void> replaceAllHabits(List<Habit> habits) async {
    await _persistAll(habits);
  }

  Future<void> _persistAll(List<Habit> habits) async {
    final maps = habits.map((h) => h.toJson()).toList();
    await _localDataSource.writeAllHabitMaps(maps);
  }
}
