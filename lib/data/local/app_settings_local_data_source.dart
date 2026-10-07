import 'package:hive_flutter/hive_flutter.dart';

/// Device-only preferences (notifications toggle, etc.).
///
/// Stored in a separate Hive box from habits so "Reset app" can clear habits
/// without accidentally wiping user preferences — or vice versa if you change
/// product rules later.
class AppSettingsLocalDataSource {
  static const String _boxName = 'habit_checklist_settings';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  Box<bool>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<bool>(_boxName);
  }

  bool get notificationsEnabled {
    final box = _box;
    if (box == null) {
      throw StateError(
        'AppSettingsLocalDataSource.init() must be called before reading.',
      );
    }
    // Default off until a notification plugin is wired up in Settings.
    return box.get(_notificationsEnabledKey, defaultValue: false) ?? false;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final box = _box;
    if (box == null) {
      throw StateError(
        'AppSettingsLocalDataSource.init() must be called before writing.',
      );
    }
    await box.put(_notificationsEnabledKey, value);
  }
}
