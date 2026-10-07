import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Low-level persistence on the device using Hive.
///
/// This class knows nothing about [Habit] — only JSON maps — so swapping
/// Hive for SQLite or a file store later means changing this file (and the
/// repository adapter), not the rest of the app.
class HabitLocalDataSource {
  static const String _boxName = 'habit_checklist_storage';
  static const String _habitsJsonKey = 'habits_json';

  Box<String>? _box;

  /// Opens the Hive box. Call once after [Hive.initFlutter] in [main].
  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Reads raw habit records from disk. Each map matches [Habit.toJson] shape.
  Future<List<Map<String, dynamic>>> readAllHabitMaps() async {
    final box = _box;
    if (box == null) {
      throw StateError(
        'HabitLocalDataSource.init() must be called before reading.',
      );
    }

    final jsonString = box.get(_habitsJsonKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  /// Overwrites all habit records on disk.
  Future<void> writeAllHabitMaps(List<Map<String, dynamic>> maps) async {
    final box = _box;
    if (box == null) {
      throw StateError(
        'HabitLocalDataSource.init() must be called before writing.',
      );
    }

    await box.put(_habitsJsonKey, jsonEncode(maps));
  }
}
