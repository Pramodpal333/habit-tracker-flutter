import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_collection/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/habit/habit_bloc.dart';
import 'blocs/habit/habit_event.dart';
import 'data/backup/backup_coordinator.dart';
import 'data/local/app_settings_local_data_source.dart';
import 'data/local/habit_local_data_source.dart';
import 'data/repositories/app_settings_repository.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/local_habit_repository.dart';
import 'screens/main_shell_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Local storage bootstrap (Android & iOS) ---
  await Hive.initFlutter();
  final localDataSource = HabitLocalDataSource();
  await localDataSource.init();

  final settingsDataSource = AppSettingsLocalDataSource();
  await settingsDataSource.init();

  // Inject local repos today; replace with Remote/Sync repos when you add a backend.
  final HabitRepository habitRepository =
      LocalHabitRepository(localDataSource);
  final AppSettingsRepository settingsRepository =
      LocalAppSettingsRepository(settingsDataSource);

  final backupCoordinator = BackupCoordinator(
    habitRepository: habitRepository,
    settingsRepository: settingsRepository,
  );

  runApp(
    HabitChecklistApp(
      habitRepository: habitRepository,
      settingsRepository: settingsRepository,
      backupCoordinator: backupCoordinator,
    ),
  );
}

class HabitChecklistApp extends StatelessWidget {
  const HabitChecklistApp({
    super.key,
    required this.habitRepository,
    required this.settingsRepository,
    required this.backupCoordinator,
  });

  final HabitRepository habitRepository;
  final AppSettingsRepository settingsRepository;
  final BackupCoordinator backupCoordinator;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HabitRepository>.value(value: habitRepository),
        RepositoryProvider<AppSettingsRepository>.value(
          value: settingsRepository,
        ),
        RepositoryProvider<BackupCoordinator>.value(
          value: backupCoordinator,
        ),
      ],
      child: BlocProvider(
        create: (context) => HabitBloc(repository: habitRepository)
          ..add(const LoadHabits()),
        child: MaterialApp(
          title: 'Habit Checklist',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          home: const MainShellScreen(),
        ),
      ),
    );
  }
}
