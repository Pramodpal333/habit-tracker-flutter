import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../models/app_backup.dart';
import '../data/backup/backup_coordinator.dart';
import '../data/repositories/app_settings_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'package:smooth_border/smooth_border.dart';

import '../widgets/app_alert_sheet.dart';
import '../widgets/app_version_label.dart';
import '../widgets/settings_tile.dart';
import 'celebration_result_screen.dart';

/// **Settings** tab — profile placeholder and app-level actions.
///
/// Habit data is cleared via [HabitBloc] + [HabitRepository]; notification
/// preference is local-only until you plug in FCM / flutter_local_notifications.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _settingsLoaded = false;
  bool _backupBusy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_settingsLoaded) {
      _notificationsEnabled =
          context.read<AppSettingsRepository>().notificationsEnabled;
      _settingsLoaded = true;
    }
  }

  Future<void> _onNotificationsChanged(bool value) async {
    setState(() => _notificationsEnabled = value);
    await context.read<AppSettingsRepository>().setNotificationsEnabled(value);

    if (!mounted) return;
    if (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reminders saved locally. Push scheduling can be added later.',
          ),
        ),
      );
    }
  }

  Future<void> _takeBackup() async {
    if (_backupBusy) return;
    setState(() => _backupBusy = true);

    try {
      final saved =
          await context.read<BackupCoordinator>().exportBackupToDevice();
      if (!mounted) return;
      if (saved) {
        await CelebrationResultScreen.showBackupSaved(context);
      }
    } on BackupException catch (e) {
      if (!mounted) return;
      await showAppInfoSheet(
        context,
        title: 'Backup failed',
        message: e.message,
        tone: AppAlertTone.warning,
      );
    } finally {
      if (mounted) setState(() => _backupBusy = false);
    }
  }

  Future<void> _importBackup() async {
    if (_backupBusy) return;

    final coordinator = context.read<BackupCoordinator>();
    AppBackup? backup;

    setState(() => _backupBusy = true);
    try {
      backup = await coordinator.pickAndParseBackupFile();
    } on BackupException catch (e) {
      if (mounted) {
        await showAppInfoSheet(
          context,
          title: 'Invalid backup',
          message: e.message,
          tone: AppAlertTone.warning,
        );
      }
      if (mounted) setState(() => _backupBusy = false);
      return;
    }

    if (!mounted) return;
    setState(() => _backupBusy = false);

    if (backup == null) return;

    final currentCount = await coordinator.currentHabitCount();
    if (!mounted) return;

    final confirmed = await showAppConfirmSheet(
      context,
      title: 'Import backup?',
      message:
          'This file contains ${backup.habits.length} habit(s), exported on '
          '${_formatBackupDate(backup.exportedAt)}.\n\n'
          'Importing will replace your $currentCount habit(s) on this device.',
      tone: AppAlertTone.warning,
      confirmLabel: 'Import backup',
      icon: Icons.file_download_rounded,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _backupBusy = true);
    try {
      await coordinator.applyBackup(backup);
      if (!mounted) return;
      context.read<HabitBloc>().add(const LoadHabits());
      setState(() {
        _notificationsEnabled =
            context.read<AppSettingsRepository>().notificationsEnabled;
      });
      await CelebrationResultScreen.showImportComplete(
        context,
        habitCount: backup.habits.length,
      );
    } on BackupException catch (e) {
      if (mounted) {
        await showAppInfoSheet(
          context,
          title: 'Import failed',
          message: e.message,
          tone: AppAlertTone.warning,
        );
      }
    } finally {
      if (mounted) setState(() => _backupBusy = false);
    }
  }

  String _formatBackupDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmResetApp() async {
    final confirmed = await showAppConfirmSheet(
      context,
      title: 'Reset app data?',
      message:
          'All habits and completion history will be deleted from this device. '
          'Your notification preference will stay as-is.',
      tone: AppAlertTone.destructive,
      confirmLabel: 'Clear data',
      icon: Icons.layers_clear_rounded,
    );

    if (confirmed != true || !mounted) return;

    context.read<HabitBloc>().add(const ClearAllHabits());
    if (!mounted) return;
    await showAppInfoSheet(
      context,
      title: 'Data cleared',
      message: 'All habits were removed from this device.',
      tone: AppAlertTone.success,
      actionLabel: 'Done',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE4E7FF),
                  Color(0xFFF0ECFF),
                  Color(0xFFE8F4FA),
                ],
              ),
              shape: SmoothRectangleBorder(borderRadius: 24, smoothing: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.face_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Habit Tracker',
                    style: AppTypography.screenTitle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Local profile — sign-in can replace this section later.',
                    textAlign: TextAlign.center,
                    style: AppTypography.emptyStateText.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Preferences',
            style: AppTypography.cardTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: AppTypography.cardTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Daily habit reminders',
                        style: AppTypography.emptyStateText.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: _notificationsEnabled,
                  activeTrackColor: AppColors.primary,
                  onChanged: _onNotificationsChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Data',
            style: AppTypography.cardTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            onTap: _backupBusy ? null : _takeBackup,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.upload_file_rounded,
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take backup',
                        style: AppTypography.cardTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Save habits & stats as a .json file on your phone',
                        style: AppTypography.emptyStateText.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (_backupBusy)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SettingsTile(
            onTap: _backupBusy ? null : _importBackup,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.download_for_offline_rounded,
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insert backup data',
                        style: AppTypography.cardTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Browse and restore from a backup file you saved',
                        style: AppTypography.emptyStateText.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (_backupBusy)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SettingsTile(
            onTap: _backupBusy ? null : _confirmResetApp,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.delete_sweep_rounded,
                  color: Colors.red,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clear data / Reset app',
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Remove all habits from this device',
                        style: AppTypography.emptyStateText.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Center(child: AppVersionLabel(fontSize: 11)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
