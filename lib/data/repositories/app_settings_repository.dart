import '../local/app_settings_local_data_source.dart';

/// Small settings surface so the Settings screen does not talk to Hive directly.
abstract class AppSettingsRepository {
  bool get notificationsEnabled;
  Future<void> setNotificationsEnabled(bool value);
}

class LocalAppSettingsRepository implements AppSettingsRepository {
  final AppSettingsLocalDataSource _dataSource;

  LocalAppSettingsRepository(this._dataSource);

  @override
  bool get notificationsEnabled => _dataSource.notificationsEnabled;

  @override
  Future<void> setNotificationsEnabled(bool value) {
    return _dataSource.setNotificationsEnabled(value);
  }
}
