import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';

/// Settings row inside a colored [SmoothContainer]-style card.
///
/// [ListTile] ink must paint on a [Material] ancestor — not on the card's
/// [DecoratedBox] — or Flutter logs "ListTile background color or ink splashes
/// may be invisible" (see project log.txt).
class SettingsTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.cardSurface,
        shape: SmoothRectangleBorder(borderRadius: 24, smoothing: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                customBorder:
                    SmoothRectangleBorder(borderRadius: 24, smoothing: 1),
                splashColor: AppColors.primary.withValues(alpha: 0.08),
                child: Padding(padding: padding, child: child),
              ),
      ),
    );
  }
}
