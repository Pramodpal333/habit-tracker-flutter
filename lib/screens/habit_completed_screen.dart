import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import '../widgets/app_gradient_scaffold.dart';
import '../widgets/celebration_backdrop.dart';
import '../widgets/habit_week_progress.dart';
import '../widgets/primary_button.dart';
import '../widgets/smooth_container.dart';
import 'habit_details_screen.dart';

/// Full-screen celebration shown when a habit is marked complete from home.
class HabitCompletedScreen extends StatefulWidget {
  final String habitId;
  final int streakCount;
  final List<DateTime> completedDates;
  final DateTime completedOn;

  const HabitCompletedScreen({
    super.key,
    required this.habitId,
    required this.streakCount,
    required this.completedDates,
    required this.completedOn,
  });

  static Future<void> show(
    BuildContext context, {
    required String habitId,
    required int streakCount,
    required List<DateTime> completedDates,
    required DateTime completedOn,
  }) {
    return Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        fullscreenDialog: true,
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.28),
        transitionDuration: const Duration(milliseconds: 520),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HabitCompletedScreen(
            habitId: habitId,
            streakCount: streakCount,
            completedDates: completedDates,
            completedOn: completedOn,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final enter = CurvedAnimation(
            parent: animation,
            curve: const Cubic(0.16, 1, 0.3, 1),
            reverseCurve: Curves.easeInCubic,
          );
          final fade = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.55, curve: Curves.easeOut),
              reverseCurve: Curves.easeIn,
            ),
          );
          final scale = Tween<double>(begin: 0.78, end: 1).animate(enter);

          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  State<HabitCompletedScreen> createState() => _HabitCompletedScreenState();
}

class _HabitCompletedScreenState extends State<HabitCompletedScreen>
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
    final streakLabel = widget.streakCount == 1
        ? '1 day streak'
        : '${widget.streakCount} day streak';

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
                    // const Spacer(flex: 2),
                    // _EntranceSlide(
                    //   delay: const Duration(milliseconds: 80),
                    //   child: Center(
                    //     child: SmoothContainer(
                    //       cornerRadius: 20,
                    //       color: AppColors.success.withValues(alpha: 0.14),
                    //       borderSide: BorderSide(
                    //         color: AppColors.success.withValues(alpha: 0.35),
                    //       ),
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 14,
                    //         vertical: 8,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(
                    //             Icons.check_circle_rounded,
                    //             size: 18,
                    //             color: AppColors.success.withValues(
                    //               alpha: 0.95,
                    //             ),
                    //           ),
                    //           const SizedBox(width: 6),
                    //           Text(
                    //             'Done for today',
                    //             style: AppTypography.buttonText.copyWith(
                    //               color: const Color(0xFF1F5A47),
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 18),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 120),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFF00FFFF)],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Habit completed!',
                          textAlign: TextAlign.center,
                          style: AppTypography.emptyStateText.copyWith(
                            fontSize: 12,
                            color: AppColors.textLight,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 46),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 180),
                      child: _StreakFireHero(
                        streakCount: widget.streakCount,
                        pulseController: _pulseController,
                      ),
                    ),
                    const SizedBox(height: 46),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 240),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFF9F5A), Color(0xFFE85D2A)],
                          ).createShader(bounds);
                        },
                        child: Text(
                          streakLabel,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 28,
                            letterSpacing: -0.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Fantastic! That's one more step closer to your goal.",
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
                    const SizedBox(height: 28),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 340),
                      child: SmoothContainer(
                        cornerRadius: 24,
                        // color: AppColors.cardSurface.withValues(alpha: 0.55),
                        borderSide: BorderSide(
                          color: AppColors.borderInactive.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            // Text(
                            //   'This week progress',
                            //   style: AppTypography.emptyStateText.copyWith(
                            //     fontSize: 13,
                            //     fontWeight: FontWeight.w600,
                            //     color: AppColors.textSecondary,
                            //   ),
                            // ),
                            const SizedBox(height: 14),
                            HabitWeekProgress(
                              completedDates: widget.completedDates,
                              anchorDate: widget.completedOn,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    _EntranceSlide(
                      delay: const Duration(milliseconds: 400),
                      child: SmoothContainer(
                        cornerRadius: 32,
                        // color: AppColors.cardSurface.withValues(alpha: 0.82),
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
                                  text: 'Habit details',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) =>
                                            HabitDetailsScreen(
                                              habitId: widget.habitId,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                _SecondarySheetButton(
                                  label: 'Back to home',
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
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

class _EntranceSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _EntranceSlide({required this.child, required this.delay});

  @override
  State<_EntranceSlide> createState() => _EntranceSlideState();
}

class _EntranceSlideState extends State<_EntranceSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.16, 1, 0.3, 1),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.94, end: 1).animate(curve);

    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

class _StreakFireHero extends StatelessWidget {
  final int streakCount;
  final AnimationController pulseController;

  const _StreakFireHero({
    required this.streakCount,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
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
          final pulse = 1 + (pulseController.value * 0.2);
          final glow = 0.28 + (pulseController.value * 0.14);
          return Transform.scale(
            scale: pulse,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withValues(alpha: glow),
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF8F2),
                    Color(0xFFFFEDE0),
                    Color(0xFFFFE0CC),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  size: 112,
                  color: Color.lerp(
                    const Color(0xFFFF9F5A),
                    const Color(0xFFE85D2A),
                    (streakCount % 7) / 7,
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

class _SecondarySheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondarySheetButton({required this.label, required this.onPressed});

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
