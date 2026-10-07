import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Shared empty list placeholder so Home and Habits tabs stay visually consistent.
class HabitsEmptyState extends StatelessWidget {
  final String message;

  const HabitsEmptyState({
    super.key,
    this.message = 'No habits added yet.\nStart by adding a new one!',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl_rounded,
            size: 80,
            color: AppColors.borderInactive,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.emptyStateText,
          ),
        ],
      ),
    );
  }
}
