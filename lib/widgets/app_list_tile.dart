import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';

/// A generic, reusable tile with aesthetic circular corners and shadows.
/// Used to display list items consistently throughout the app.
class AppListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppListTile({
    super.key,
    required this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: ShapeDecoration(
        color: Theme.of(context).cardTheme.color ?? AppColors.cardSurface,
        shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
        shadows: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
