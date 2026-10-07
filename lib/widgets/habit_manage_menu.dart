import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'habit_manage_action.dart';

/// Shows a squircle action sheet anchored to the ⋮ button (not stock [PopupMenuButton]).
Future<HabitManageAction?> showHabitManageMenu(
  BuildContext context, {
  required BuildContext anchorContext,
}) {
  final renderBox = anchorContext.findRenderObject()! as RenderBox;
  final overlay =
      Overlay.of(context).context.findRenderObject()! as RenderBox;

  final buttonOrigin =
      renderBox.localToGlobal(Offset.zero, ancestor: overlay);
  const menuWidth = 252.0;

  final left = (buttonOrigin.dx + renderBox.size.width - menuWidth).clamp(
    16.0,
    overlay.size.width - menuWidth - 16,
  );
  final top = buttonOrigin.dy + renderBox.size.height + 8;

  return showGeneralDialog<HabitManageAction>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.12),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: menuWidth,
              child: _HabitManageMenuPanel(
                onSelected: (action) =>
                    Navigator.of(context).pop(action),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
          alignment: Alignment.topRight,
          child: child,
        ),
      );
    },
  );
}

class _HabitManageMenuPanel extends StatelessWidget {
  final ValueChanged<HabitManageAction> onSelected;

  const _HabitManageMenuPanel({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFAFBFF), Color(0xFFF3F0FF)],
        ),
        shadows: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
        shape: SmoothRectangleBorder(
          borderRadius: 22,
          smoothing: 1,
          side: BorderSide(
            color: AppColors.borderInactive.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: SmoothRectangleBorder(borderRadius: 22, smoothing: 1),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MenuRow(
              icon: Icons.query_stats_rounded,
              label: 'See analytics',
              iconBackground: AppColors.primary.withValues(alpha: 0.14),
              iconColor: AppColors.primary,
              onTap: () => onSelected(HabitManageAction.seeAnalytics),
            ),
            Divider(
              height: 1,
              color: AppColors.borderInactive.withValues(alpha: 0.6),
            ),
            _MenuRow(
              icon: Icons.edit_note_rounded,
              label: 'Edit habit',
              iconBackground: const Color(0xFFFFE8B0).withValues(alpha: 0.55),
              iconColor: const Color(0xFF8A5E0C),
              onTap: () => onSelected(HabitManageAction.editHabit),
            ),
            Divider(
              height: 1,
              color: AppColors.borderInactive.withValues(alpha: 0.6),
            ),
            _MenuRow(
              icon: Icons.delete_forever_rounded,
              label: 'Delete habit',
              iconBackground: const Color(0xFFFFD4D8),
              iconColor: const Color(0xFF9E2B36),
              labelColor: const Color(0xFF9E2B36),
              onTap: () => onSelected(HabitManageAction.deleteHabit),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBackground;
  final Color iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: iconBackground,
                shape: SmoothRectangleBorder(
                  borderRadius: 14,
                  smoothing: 0.85,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 22, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
