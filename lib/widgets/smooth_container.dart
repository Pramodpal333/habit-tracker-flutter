import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

/// A reusable container that uses an iOS-style smooth corner (squircle)
/// instead of the standard circular border radius.
class SmoothContainer extends StatelessWidget {
  final Widget? child;
  final double cornerRadius;
  final double cornerSmoothing;
  final Color? color;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderSide? borderSide;

  const SmoothContainer({
    super.key,
    this.child,
    this.cornerRadius = 24.0,
    this.cornerSmoothing = 1.0, // 1.0 is full smoothing (iOS style squircle)
    this.color,
    this.gradient,
    this.shadows,
    this.padding,
    this.margin,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        gradient: gradient,
        color: gradient == null ? color : null,
        shadows: shadows,
        shape: SmoothRectangleBorder(
          side: borderSide ?? BorderSide.none,
          borderRadius: cornerRadius,
          smoothing: cornerSmoothing,
        ),
      ),
      child: child,
    );
  }
}
