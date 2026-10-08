import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../core/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';

/// Visual intent for [showAppConfirmSheet] / [showAppInfoSheet].
enum AppAlertTone { neutral, destructive, warning, success }

/// Shared confirm / info bottom sheets — use instead of [AlertDialog] for a
/// consistent squircle look with the rest of the app (add habit, menus, etc.).
class AppAlertSheet extends StatelessWidget {
  final String title;
  final String message;
  final AppAlertTone tone;
  final String? confirmLabel;
  final String cancelLabel;
  final IconData? icon;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppAlertSheet({
    super.key,
    required this.title,
    required this.message,
    this.tone = AppAlertTone.neutral,
    this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.icon,
    this.onConfirm,
    this.onCancel,
  });

  _ToneStyle get _style => _ToneStyle.forTone(tone, icon);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0 + bottomInset),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFAFBFF), Color(0xFFF4F0FF)],
          ),
          shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
          shadows: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: SmoothRectangleBorder(borderRadius: 32, smoothing: 1),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderInactive,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: _style.iconBackground,
                    shape: SmoothRectangleBorder(
                      borderRadius: 18,
                      smoothing: 0.9,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(_style.icon, size: 28, color: _style.iconColor),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.screenTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyStateText.copyWith(
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                if (confirmLabel != null) ...[
                  _AlertActionButton(
                    label: confirmLabel!,
                    gradient: _style.confirmGradient,
                    textColor: AppColors.textLight,
                    onPressed: onConfirm,
                  ),
                  const SizedBox(height: 10),
                  _AlertActionButton(
                    label: cancelLabel,
                    gradient: null,
                    textColor: AppColors.textPrimary,
                    outlined: true,
                    onPressed: onCancel,
                  ),
                ] else
                  _AlertActionButton(
                    label: cancelLabel,
                    gradient: AppGradients.primaryButton,
                    textColor: AppColors.textLight,
                    onPressed: onCancel,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToneStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final LinearGradient confirmGradient;

  const _ToneStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.confirmGradient,
  });

  static _ToneStyle forTone(AppAlertTone tone, IconData? overrideIcon) {
    return switch (tone) {
      AppAlertTone.destructive => _ToneStyle(
        icon: overrideIcon ?? Icons.delete_forever_rounded,
        iconColor: const Color(0xFF9E2B36),
        iconBackground: const Color(0xFFFFD4D8),
        confirmGradient: const LinearGradient(
          colors: [Color(0xFFE85D5D), Color(0xFFD84343)],
        ),
      ),
      AppAlertTone.warning => _ToneStyle(
        icon: overrideIcon ?? Icons.warning_amber_rounded,
        iconColor: const Color(0xFF8A5E0C),
        iconBackground: const Color(0xFFFFE8B0),
        confirmGradient: const LinearGradient(
          colors: [Color(0xFFE8B85C), Color(0xFFDFAE4F)],
        ),
      ),
      AppAlertTone.success => _ToneStyle(
        icon: overrideIcon ?? Icons.check_circle_rounded,
        iconColor: const Color(0xFF1F5A47),
        iconBackground: const Color(0xFFB8E6D5),
        confirmGradient: const LinearGradient(
          colors: [Color(0xFF66DE93), Color(0xFF5CB8A5)],
        ),
      ),
      AppAlertTone.neutral => _ToneStyle(
        icon: overrideIcon ?? Icons.info_outline_rounded,
        iconColor: AppColors.primary,
        iconBackground: AppColors.primary.withValues(alpha: 0.14),
        confirmGradient: AppGradients.primaryButton,
      ),
    };
  }
}

class _AlertActionButton extends StatelessWidget {
  final String label;
  final LinearGradient? gradient;
  final Color textColor;
  final bool outlined;
  final VoidCallback? onPressed;

  const _AlertActionButton({
    required this.label,
    required this.gradient,
    required this.textColor,
    this.outlined = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: outlined ? null : gradient,
          color: outlined ? AppColors.cardSurface : null,
          shape: SmoothRectangleBorder(
            borderRadius: 22,
            smoothing: 1,
            side: outlined
                ? BorderSide(
                    color: AppColors.borderInactive.withValues(alpha: 0.9),
                  )
                : BorderSide.none,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: AppHaptics.wrapButton(onPressed),
            customBorder: SmoothRectangleBorder(borderRadius: 22, smoothing: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.buttonText.copyWith(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-button sheet — returns `true` (confirm), `false` (cancel), or `null` (dismiss).
Future<bool?> showAppConfirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  AppAlertTone tone = AppAlertTone.neutral,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  IconData? icon,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (sheetContext) {
      return AppAlertSheet(
        title: title,
        message: message,
        tone: tone,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        onConfirm: () => Navigator.pop(sheetContext, true),
        onCancel: () => Navigator.pop(sheetContext, false),
      );
    },
  );
}

/// Single-button informational sheet (errors, tips, success messages).
Future<void> showAppInfoSheet(
  BuildContext context, {
  required String title,
  required String message,
  AppAlertTone tone = AppAlertTone.neutral,
  String actionLabel = 'Got it',
  IconData? icon,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (sheetContext) {
      return AppAlertSheet(
        title: title,
        message: message,
        tone: tone,
        cancelLabel: actionLabel,
        icon: icon,
        onCancel: () => Navigator.pop(sheetContext),
      );
    },
  );
}
