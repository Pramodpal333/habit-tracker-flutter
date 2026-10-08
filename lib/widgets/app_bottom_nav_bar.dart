import 'package:flutter/material.dart';
import 'package:smooth_border/smooth_border.dart';

import '../core/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';

/// Custom bottom bar — matches app squircle cards instead of stock [NavigationBar].
class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _items = [
    _NavItem(
      label: 'Home',
      icon: Icons.wb_sunny_outlined,
      selectedIcon: Icons.wb_sunny_rounded,
    ),
    _NavItem(
      label: 'Habits',
      icon: Icons.layers_outlined,
      selectedIcon: Icons.layers_rounded,
    ),
    _NavItem(
      label: 'Settings',
      icon: Icons.account_circle_outlined,
      selectedIcon: Icons.account_circle_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: AppGradients.bottomNav,
          shadows: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          shape: SmoothRectangleBorder(
            borderRadius: 28,
            smoothing: 1,
            side: BorderSide(
              color: AppColors.borderInactive.withValues(alpha: 0.6),
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = index == selectedIndex;
                return Expanded(
                  child: _NavBarButton(
                    item: item,
                    selected: selected,
                    onTap: () => onSelected(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class _NavBarButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: AppHaptics.wrapButton(onTap)!,
      borderRadius: BorderRadius.circular(20),
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.primary.withValues(alpha: 0.06),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: ShapeDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x337C83FD),
                    Color(0x22969BFF),
                  ],
                )
              : null,
          color: selected ? null : Colors.transparent,
          shape: SmoothRectangleBorder(
            borderRadius: 20,
            smoothing: 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.selectedIcon : item.icon,
              size: 26,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTypography.emptyStateText.copyWith(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
