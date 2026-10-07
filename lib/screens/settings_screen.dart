import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../data/repositories/app_settings_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/settings_tile.dart';
import '../widgets/smooth_container.dart';

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

  Future<void> _confirmResetApp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset app data?'),
        content: const Text(
          'All habits and completion history will be deleted from this device. '
          'Your notification preference will stay as-is.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear data', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<HabitBloc>().add(const ClearAllHabits());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All habit data cleared')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          SmoothContainer(
            color: AppColors.cardSurface,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
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
            onTap: _confirmResetApp,
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
        ],
      ),
    );
  }
}
