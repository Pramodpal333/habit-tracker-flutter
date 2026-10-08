import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../navigation/celebration_page_route.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import '../widgets/app_gradient_scaffold.dart';
import '../widgets/celebration_backdrop.dart';
import '../widgets/celebration_entrance.dart';
import '../widgets/primary_button.dart';
import '../widgets/smooth_container.dart';
import 'main_shell_screen.dart';

enum CelebrationHeroTheme { success, primary }

/// Full-screen success flow (backup saved, import complete, etc.).
class CelebrationResultScreen extends StatefulWidget {
  final String eyebrow;
  final String headline;
  final String? highlight;
  final String message;
  final IconData heroIcon;
  final CelebrationHeroTheme heroTheme;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const CelebrationResultScreen._({
    required this.eyebrow,
    required this.headline,
    this.highlight,
    required this.message,
    required this.heroIcon,
    required this.heroTheme,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  static Future<void> showBackupSaved(BuildContext context) {
    return pushCelebrationPage<void>(
      context,
      page: CelebrationResultScreen._(
        eyebrow: 'All set',
        headline: 'Backup saved',
        message:
            'Use the share sheet to save the backup (Files, Drive, etc.). '
            'Keep that .json file somewhere safe.',
        heroIcon: Icons.cloud_done_rounded,
        heroTheme: CelebrationHeroTheme.success,
        primaryLabel: 'Back to settings',
        onPrimary: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Future<void> showImportComplete(
    BuildContext context, {
    required int habitCount,
  }) {
    final habitLabel =
        habitCount == 1 ? '1 habit restored' : '$habitCount habits restored';

    return pushCelebrationPage<void>(
      context,
      page: CelebrationResultScreen._(
        eyebrow: 'Welcome back',
        headline: 'Import complete',
        highlight: habitLabel,
        message:
            'Your habits and full completion history are back on this device.',
        heroIcon: Icons.inventory_rounded,
        heroTheme: CelebrationHeroTheme.primary,
        primaryLabel: 'Go to home',
        onPrimary: () {
          Navigator.of(context).pop();
          MainShellScreen.selectTab(context, 0);
        },
        secondaryLabel: 'Back to settings',
        onSecondary: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<CelebrationResultScreen> createState() =>
      _CelebrationResultScreenState();
}

class _CelebrationResultScreenState extends State<CelebrationResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const CelebrationBackdrop(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    CelebrationEntrance(
                      delay: const Duration(milliseconds: 120),
                      child: Text(
                        widget.eyebrow,
                        textAlign: TextAlign.center,
                        style: AppTypography.emptyStateText.copyWith(
                          fontSize: 12,
                          letterSpacing: 0.6,
                          color: AppColors.textLight.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 46),
                    CelebrationEntrance(
                      delay: const Duration(milliseconds: 180),
                      child: _CelebrationHeroIcon(
                        icon: widget.heroIcon,
                        theme: widget.heroTheme,
                        pulseController: _pulseController,
                      ),
                    ),
                    const SizedBox(height: 46),
                    CelebrationEntrance(
                      delay: const Duration(milliseconds: 240),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: widget.heroTheme == CelebrationHeroTheme.success
                                ? const [
                                    Color(0xFF66DE93),
                                    Color(0xFF5CB8A5),
                                  ]
                                : const [
                                    Color(0xFF969BFF),
                                    Color(0xFF7C83FD),
                                  ],
                          ).createShader(bounds);
                        },
                        child: Text(
                          widget.headline,
                          textAlign: TextAlign.center,
                          style: AppTypography.screenTitle.copyWith(
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    if (widget.highlight != null) ...[
                      const SizedBox(height: 12),
                      CelebrationEntrance(
                        delay: const Duration(milliseconds: 280),
                        child: Text(
                          widget.highlight!,
                          textAlign: TextAlign.center,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 20,
                            color: AppColors.textLight.withValues(alpha: 0.92),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    CelebrationEntrance(
                      delay: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: AppTypography.emptyStateText.copyWith(
                            fontSize: 16,
                            height: 1.55,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.95,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    CelebrationEntrance(
                      delay: const Duration(milliseconds: 400),
                      child: SmoothContainer(
                        cornerRadius: 32,
                        shadows: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Column(
                              children: [
                                PrimaryButton(
                                  text: widget.primaryLabel,
                                  onPressed: widget.onPrimary,
                                ),
                                if (widget.secondaryLabel != null &&
                                    widget.onSecondary != null) ...[
                                  const SizedBox(height: 10),
                                  _SecondaryCelebrationButton(
                                    label: widget.secondaryLabel!,
                                    onPressed: widget.onSecondary!,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationHeroIcon extends StatelessWidget {
  final IconData icon;
  final CelebrationHeroTheme theme;
  final AnimationController pulseController;

  const _CelebrationHeroIcon({
    required this.icon,
    required this.theme,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    final accent = theme == CelebrationHeroTheme.success
        ? AppColors.success
        : AppColors.primary;
    final innerGradient = theme == CelebrationHeroTheme.success
        ? const [
            Color(0xFFE8FFF3),
            Color(0xFFD4F5E6),
            Color(0xFFC8EDE0),
          ]
        : const [
            Color(0xFFF4F6FF),
            Color(0xFFE8ECFF),
            Color(0xFFDFE4FF),
          ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 680),
      curve: const Cubic(0.16, 1, 0.3, 1),
      builder: (context, introScale, child) {
        return Transform.scale(scale: introScale, child: child);
      },
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          final pulse = 1 + (pulseController.value * 0.06);
          final glow = 0.28 + (pulseController.value * 0.14);
          return Transform.scale(
            scale: pulse,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: glow),
                    blurRadius: 56,
                    spreadRadius: 6,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.fab,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 0,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: innerGradient,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Icon(icon, size: 96, color: accent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCelebrationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondaryCelebrationButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.cardSurface,
          shape: SmoothRectangleBorder(
            borderRadius: 24,
            smoothing: 1,
            side: BorderSide(
              color: AppColors.borderInactive.withValues(alpha: 0.85),
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: SmoothRectangleBorder(borderRadius: 24, smoothing: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.buttonText.copyWith(
                    color: AppColors.textPrimary,
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
