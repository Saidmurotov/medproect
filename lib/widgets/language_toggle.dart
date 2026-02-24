import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/language_provider.dart';

/// Compact language toggle switch: UZ ↔ RU
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isUz = langProvider.locale.languageCode == 'uz';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
            label: 'UZ',
            flag: '🇺🇿',
            isActive: isUz,
            onTap: () => langProvider.setLocale(const Locale('uz')),
          ),
          _LangChip(
            label: 'RU',
            flag: '🇷🇺',
            isActive: !isUz,
            onTap: () => langProvider.setLocale(const Locale('ru')),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final String flag;
  final bool isActive;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.flag,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
