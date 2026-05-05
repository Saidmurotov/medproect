import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../l10n/app_localizations.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: l10n.home,
                  isActive: currentIndex == 0,
                  onTap: () => _navigate(context, 0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.favorite_outline_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: l10n.symptoms,
                  isActive: currentIndex == 1,
                  onTap: () => _navigate(context, 1),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: l10n.profile,
                  isActive: currentIndex == 2,
                  onTap: () => _navigate(context, 2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.medication_outlined,
                  activeIcon: Icons.medication,
                  label: l10n.medications,
                  isActive: currentIndex == 3,
                  onTap: () => _navigate(context, 3),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.restaurant_menu_outlined,
                  activeIcon: Icons.restaurant_menu_rounded,
                  label: l10n.foodCamera,
                  isActive: currentIndex == 4,
                  onTap: () => _navigate(context, 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        if (currentIndex == 0) {
          Navigator.pushNamed(context, '/add-symptom');
        } else {
          Navigator.pushReplacementNamed(context, '/add-symptom');
        }
        break;
      case 2:
        if (currentIndex == 0) {
          Navigator.pushNamed(context, '/report');
        } else {
          Navigator.pushReplacementNamed(context, '/report');
        }
        break;
      case 3:
        if (currentIndex == 0) {
          Navigator.pushNamed(context, '/medications');
        } else {
          Navigator.pushReplacementNamed(context, '/medications');
        }
        break;
      case 4:
        Navigator.pushNamed(context, '/food-camera');
        break;
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
