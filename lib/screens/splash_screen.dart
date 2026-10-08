import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_gradient_scaffold.dart';
import '../widgets/celebration_backdrop.dart';
import 'main_shell_screen.dart';

/// Branded intro shown on cold start (~5s), then [MainShellScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration displayDuration = Duration(seconds: 10005);
  static const String logoAsset = 'assets/app-brandings/app-logo.png';
  static const String tagline = 'Small steps.\nLasting change.';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _enterController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _taglineOpacity;
  Timer? _navigateTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    final enterCurve = CurvedAnimation(
      parent: _enterController,
      curve: const Cubic(0.16, 1, 0.3, 1),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(enterCurve);
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.35, 1, curve: Curves.easeOut),
      ),
    );

    _enterController.forward();
    _navigateTimer = Timer(SplashScreen.displayDuration, _openHome);
  }

  void _openHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const MainShellScreen();
        },
        transitionDuration: const Duration(milliseconds: 480),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: const Cubic(0.16, 1, 0.3, 1),
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.02, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    _pulseController.dispose();
    _enterController.dispose();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FadeTransition(
                  opacity: _taglineOpacity,
                  child: Text(
                    'Made by Pramod Pal',
                    textAlign: TextAlign.center,
                    style: AppTypography.emptyStateText.copyWith(
                      fontSize: 10,
                      height: 1,
                      letterSpacing: 1,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: _SplashLogo(pulseController: _pulseController),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _taglineOpacity,
                      child: Text(
                        SplashScreen.tagline,
                        textAlign: TextAlign.center,
                        style: AppTypography.emptyStateText.copyWith(
                          fontSize: 12,
                          height: 1.45,
                          letterSpacing: 1,
                          color: AppColors.textLight.withValues(alpha: 0.95),
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

class _SplashLogo extends StatelessWidget {
  final AnimationController pulseController;

  const _SplashLogo({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glow = 0.22 + (pulseController.value * 0.4);
        final scale = 1 + (pulseController.value * 0.15);
        return Transform.scale(
          scale: scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: glow),
                  blurRadius: 56,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: const Color(0xFFFF8C42).withValues(alpha: glow * 0.55),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Image.asset(
          SplashScreen.logoAsset,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
