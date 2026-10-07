import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A highly reusable circular checkbox used in lists or forms.
class CircularCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  const CircularCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isChecked);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked ? AppColors.success : AppColors.borderInactive,
            width: 2,
          ),
          color: isChecked ? AppColors.success : Colors.transparent,
        ),
        child: isChecked
            ? const Icon(Icons.check, size: 18, color: AppColors.textLight)
            : null,
      ),
    );
  }
}
