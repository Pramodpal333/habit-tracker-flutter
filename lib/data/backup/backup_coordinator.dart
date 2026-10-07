import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/storage_permissions.dart';
import '../../models/app_backup.dart';
import '../repositories/app_settings_repository.dart';
import '../repositories/habit_repository.dart';

/// Builds backup payloads and reads/writes `.json` via the system file UI.
///
/// Export uses the **share sheet** (Save to Files, Drive, etc.) so it works even
/// when [FilePicker.saveFile] is unavailable. Import uses the system file browser.
class BackupCoordinator {
  final HabitRepository _habitRepository;
  final AppSettingsRepository _settingsRepository;

  BackupCoordinator({
    required HabitRepository habitRepository,
    required AppSettingsRepository settingsRepository,
  })  : _habitRepository = habitRepository,
        _settingsRepository = settingsRepository;

  Future<AppBackup> createBackupPayload() async {
    final habits = await _habitRepository.getHabits();
    return AppBackup(
      backupVersion: AppBackup.currentVersion,
      exportedAt: DateTime.now(),
      habits: habits,
      notificationsEnabled: _settingsRepository.notificationsEnabled,
    );
  }

  /// Lets the user save backup JSON via share sheet / "Save to Files".
  ///
  /// Returns `true` if the share UI was shown (user may still cancel).
  Future<bool> exportBackupToDevice() async {
    final allowed = await StoragePermissions.ensureForBackup(
      showSystemDialog: true,
    );
    if (!allowed) {
      throw BackupException(
        'Storage permission is required to export a backup on this device.',
      );
    }

    final payload = await createBackupPayload();
    final json = payload.encode();
    final date = payload.exportedAt.toIso8601String().split('T').first;
    final fileName = 'habit_checklist_backup_$date.json';

    // Prefer share sheet — avoids MissingPluginException on saveFile after hot reload.
    try {
      return await _exportViaShareSheet(fileName, json);
    } on MissingPluginException {
      return _exportViaFilePickerSave(fileName, json);
    }
  }

  Future<bool> _exportViaShareSheet(String fileName, String json) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(json, flush: true);

    final result = await Share.shareXFiles(
      [
        XFile(
          file.path,
          name: fileName,
          mimeType: 'application/json',
        ),
      ],
      subject: 'Habit Checklist backup',
      text: 'Save this file to restore your habits later.',
    );
    return result.status != ShareResultStatus.unavailable;
  }

  Future<bool> _exportViaFilePickerSave(String fileName, String json) async {
    final bytes = Uint8List.fromList(utf8.encode(json));
    final savedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save habit backup',
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    return savedPath != null;
  }

  Future<AppBackup?> pickAndParseBackupFile() async {
    final allowed = await StoragePermissions.ensureForBackup(
      showSystemDialog: true,
    );
    if (!allowed) {
      throw BackupException(
        'Storage permission is required to import a backup on this device.',
      );
    }

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
        dialogTitle: 'Select a backup file',
      );
    } on MissingPluginException {
      throw BackupException(
        'File picker is not ready. Stop the app completely, then run '
        '`flutter clean && flutter pub get` and launch again (not hot reload).',
      );
    }

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    var bytes = file.bytes;

    if (bytes == null && file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    }

    if (bytes == null) {
      throw BackupException(
        'Could not read "${file.name}". Try moving the file to Downloads and pick again.',
      );
    }

    try {
      return AppBackup.decode(utf8.decode(bytes));
    } on FormatException catch (e) {
      throw BackupException(e.message);
    }
  }

  Future<void> applyBackup(AppBackup backup) async {
    await _habitRepository.replaceAllHabits(backup.habits);
    await _settingsRepository.setNotificationsEnabled(
      backup.notificationsEnabled,
    );
  }

  Future<int> currentHabitCount() async {
    final habits = await _habitRepository.getHabits();
    return habits.length;
  }
}

class BackupException implements Exception {
  final String message;
  BackupException(this.message);

  @override
  String toString() => message;
}
