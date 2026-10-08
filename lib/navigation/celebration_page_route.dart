import 'package:flutter/material.dart';

Future<T?> pushCelebrationPage<T>(
  BuildContext context, {
  required Widget page,
}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder<T>(
      fullscreenDialog: true,
      opaque: false,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      transitionDuration: const Duration(milliseconds: 520),
      reverseTransitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, animation, secondaryAnimation) => page,
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
