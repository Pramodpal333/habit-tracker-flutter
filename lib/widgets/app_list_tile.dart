import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';

/// A generic, reusable tile with aesthetic circular corners and shadows.
/// Used to display list items consistently throughout the app.
class AppListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// When set (e.g. from habit priority), the tile uses a soft gradient fill.
  final Gradient? gradient;

  /// Shadow tint; defaults to primary when no [gradient].
  final Color? shadowTint;

  const AppListTile({
    super.key,
    required this.leading,
    this.trailing,
    this.onTap,
    this.gradient,
    this.shadowTint,
  });

  @override
  Widget build(BuildContext context) {
    final tint = shadowTint ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: ShapeDecoration(
        gradient: gradient,
        color: gradient == null
            ? (Theme.of(context).cardTheme.color ?? AppColors.cardSurface)
            : null,
        shape: SmoothRectangleBorder(
          borderRadius: 32,
          smoothing: 1,
          side: gradient != null
              ? BorderSide(color: tint.withValues(alpha: 0.12))
              : BorderSide.none,
        ),
        shadows: [
          BoxShadow(
            color: tint.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: SmoothRectangleBorder(borderRadius: 24, smoothing: 0.6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 32.0,
            ),
            child: Row(
              children: [
                Expanded(child: leading),
                const SizedBox(width: 16),
                if (trailing != null) ...[const SizedBox(width: 16), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
