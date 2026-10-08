import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft blurred orbs used on splash and habit-completed screens.
class CelebrationBackdrop extends StatelessWidget {
  const CelebrationBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -40,
          child: _GlowOrb(
            size: 220,
            color: AppColors.primary.withValues(alpha: 0.22),
          ),
        ),
        Positioned(
          top: 120,
          left: -60,
          child: _GlowOrb(
            size: 180,
            color: const Color(0xFFFF8C42).withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: 80,
          right: -20,
          child: _GlowOrb(
            size: 160,
            color: AppColors.success.withValues(alpha: 0.16),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
