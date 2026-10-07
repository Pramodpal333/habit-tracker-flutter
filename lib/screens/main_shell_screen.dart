import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'add_habit_screen.dart';
import 'habits_management_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Root scaffold after launch — hosts bottom navigation and tab bodies.
///
/// We use [IndexedStack] instead of swapping a single child so each tab keeps
/// its scroll position when the user switches tabs (common Material pattern).
/// The add-habit FAB lives here (not on every tab) because only Home creates habits.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  static const _tabs = <Widget>[
    HomeScreen(),
    HabitsManagementScreen(),
    SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openAddHabitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
      builder: (context) => const AddHabitScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _openAddHabitSheet,
              shape: SmoothRectangleBorder(borderRadius: 30, smoothing: 1),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onSelected: _onTabSelected,
      ),
    );
  }
}
