import 'package:flutter/material.dart';

/// Centralized color palette for the app.
/// Uses vibrant but subtle colors for an aesthetic look.
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF7C83FD); // Vibrant but soft periwinkle/indigo
  static const Color primaryLight = Color(0xFF969BFF); // Lighter shade of primary
  
  // Background colors
  static const Color background = Color(0xFFF4F6FF); // Very subtle cool tinted white
  static const Color cardSurface = Color(0xFFFFFFFF); // Clean white for elevated cards
  
  // State colors
  static const Color success = Color(0xFF66DE93); // Soft vibrant mint green for completed tasks
  static const Color borderInactive = Color(0xFFE2E8F0); // Light slate for empty checkboxes
  
  // Typography colors
  static const Color textPrimary = Color(0xFF2A2D43); // Soft dark navy for high contrast text
  static const Color textSecondary = Color(0xFF7D8597); // Subtle grayish blue for secondary text
  static const Color textLight = Color(0xFFFFFFFF); // White text on colored backgrounds
}
