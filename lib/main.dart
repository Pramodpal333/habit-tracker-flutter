import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_collection/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/habit/habit_bloc.dart';
import 'blocs/habit/habit_event.dart';
import 'data/local/habit_local_data_source.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/local_habit_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Local storage bootstrap (Android & iOS) ---
  await Hive.initFlutter();
  final localDataSource = HabitLocalDataSource();
  await localDataSource.init();

  // Inject local repo today; replace with Remote/Sync repo when you add a backend.
  final HabitRepository habitRepository =
      LocalHabitRepository(localDataSource);

  runApp(HabitChecklistApp(habitRepository: habitRepository));
}

class HabitChecklistApp extends StatelessWidget {
  const HabitChecklistApp({
    super.key,
    required this.habitRepository,
  });

  /// Single swap point when moving from local-only to API/Firebase.
  final HabitRepository habitRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
        home: const HomeScreen(),
      ),
    );
  }
}
