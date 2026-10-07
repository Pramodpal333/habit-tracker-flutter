import 'package:flutter/material.dart';

import '../models/habit_priority.dart';

/// Soft, muted gradients used across the app (not flat fills).
///
/// Habit tiles pick a variant from [habitTileGradient] using [habitId] so each
/// habit keeps a stable "random" shade within its priority family (green / amber / rose).
class AppGradients {
  AppGradients._();

  /// Full-screen backdrop behind all tabs in [MainShellScreen].
  static const LinearGradient scaffold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8ECFF),
      Color(0xFFF3EEFF),
      Color(0xFFE6F3F8),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient fab = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B92FF),
      Color(0xFF7C83FD),
      Color(0xFF9B7CFD),
    ],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF7C83FD),
      Color(0xFF969BFF),
    ],
  );

  static const LinearGradient bottomNav = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFCFCFF),
      Color(0xFFF5F3FF),
    ],
  );

  static LinearGradient habitTileGradient(
    HabitPriority priority,
    String habitId,
  ) {
    final variants = switch (priority) {
      HabitPriority.low => _lowTileVariants,
      HabitPriority.medium => _mediumTileVariants,
      HabitPriority.high => _highTileVariants,
    };
    final index = habitId.hashCode.abs() % variants.length;
    return variants[index];
  }

  /// Muted green family — richer mid-tones (less wash-out toward white).
  static const List<LinearGradient> _lowTileVariants = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7FBFA8), Color(0xFFA8D9C6)],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xFF72B59C), Color(0xFF9FD4BF)],
    ),
    LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF6EAE96), Color(0xFF95CEB8)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF85C4AD), Color(0xFFABDEC9)],
    ),
  ];

  static const List<LinearGradient> _mediumTileVariants = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE8B85C), Color(0xFFF0CC7A)],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xFFDFAE4F), Color(0xFFEAC268)],
    ),
    LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFD9A647), Color(0xFFE8BE62)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFFEEC06A), Color(0xFFF5D080)],
    ),
  ];

  static const List<LinearGradient> _highTileVariants = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE8878F), Color(0xFFF0A3AA)],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xFFDF7882), Color(0xFFEB959E)],
    ),
    LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFD86E79), Color(0xFFE88A94)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFFEC929A), Color(0xFFF5ACB2)],
    ),
  ];
}
