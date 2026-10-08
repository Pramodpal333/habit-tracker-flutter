import 'package:flutter/material.dart';

import '../core/app_version.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Small `v1.x.x` label synced with [pubspec.yaml] via [AppVersion.init].
class AppVersionLabel extends StatelessWidget {
  final Color? color;
  final double fontSize;

  const AppVersionLabel({
    super.key,
    this.color,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      AppVersion.label,
      textAlign: TextAlign.center,
      style: AppTypography.emptyStateText.copyWith(
        fontSize: fontSize,
        height: 1.2,
        letterSpacing: 0.4,
        color: color ?? AppColors.textSecondary.withValues(alpha: 0.75),
      ),
    );
  }
}
