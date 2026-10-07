import 'dart:convert';

import 'habit_model.dart';

/// JSON envelope for export/import so cloud sync can reuse the same shape later.
class AppBackup {
  static const int currentVersion = 1;
  static const String appId = 'habit_checklist';

  final int backupVersion;
  final DateTime exportedAt;
  final List<Habit> habits;
  final bool notificationsEnabled;

  const AppBackup({
    required this.backupVersion,
    required this.exportedAt,
    required this.habits,
    required this.notificationsEnabled,
  });

  Map<String, dynamic> toJson() => {
        'backupVersion': backupVersion,
        'app': appId,
        'exportedAt': exportedAt.toIso8601String(),
        'habits': habits.map((h) => h.toJson()).toList(),
        'settings': {
          'notificationsEnabled': notificationsEnabled,
        },
      };

  factory AppBackup.fromJson(Map<String, dynamic> json) {
    final version = json['backupVersion'] as int?;
    if (version == null || version > currentVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    final app = json['app'] as String?;
    if (app != null && app != appId) {
      throw FormatException('This file is not a Habit Checklist backup.');
    }

    final habitsJson = json['habits'] as List<dynamic>? ?? [];
    final settings = json['settings'] as Map<String, dynamic>? ?? {};

    return AppBackup(
      backupVersion: version,
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      habits: habitsJson
          .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      notificationsEnabled:
          settings['notificationsEnabled'] as bool? ?? false,
    );
  }

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  static AppBackup decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup file must be a JSON object.');
    }
    return AppBackup.fromJson(decoded);
  }
}
