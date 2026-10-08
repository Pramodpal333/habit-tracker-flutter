import 'package:flutter/services.dart';

/// Consistent haptic feedback across the app.
abstract final class AppHaptics {
  /// Standard tap — buttons, tabs, settings rows, etc.
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Strong feedback — marking a habit complete for the day.
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Wraps [action] with [medium] when non-null (for `onPressed` / `onTap`).
  static VoidCallback? wrapButton(VoidCallback? action) {
    if (action == null) return null;
    return () {
      medium();
      action();
    };
  }
}
