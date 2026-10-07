import 'package:equatable/equatable.dart';

import 'habit_priority.dart';

/// Represents a single habit to be tracked.
class Habit extends Equatable {
  final String id;
  final String title;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final HabitPriority priority;

  const Habit({
    required this.id,
    required this.title,
    this.completedDates = const [],
    required this.createdAt,
    this.priority = HabitPriority.medium,
  });

  /// Whether this habit was marked complete on [date] (calendar day only).
  bool isCompletedOn(DateTime date) {
    return completedDates.any(
      (d) =>
          d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// Check if the habit is completed today
  bool get isDoneToday => isCompletedOn(DateTime.now());

  /// Serializes this habit for local storage or future API payloads.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completedDates':
          completedDates.map((d) => d.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'priority': priority.name,
    };
  }

  /// Restores a habit from JSON (local Hive box or remote API response).
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      completedDates: (json['completedDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      priority: HabitPriority.fromStorage(json['priority'] as String?),
    );
  }

  /// Creates a copy of this Habit but with the given fields replaced with the new values.
  Habit copyWith({
    String? id,
    String? title,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    HabitPriority? priority,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, title, completedDates, createdAt, priority];
}
