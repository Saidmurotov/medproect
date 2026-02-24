import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../l10n/app_localizations.dart';

/// Real-time email validation indicator
class EmailValidationHint extends StatelessWidget {
  final String email;

  const EmailValidationHint({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    if (email.isEmpty) return const SizedBox.shrink();

    final isValid = _isValidEmail(email);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey(isValid),
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.info_outline,
            size: 14,
            color: isValid ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: 6),
          Text(
            isValid
                ? AppLocalizations.of(context)!.emailValid
                : AppLocalizations.of(context)!.emailInvalid,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isValid ? AppColors.success : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$').hasMatch(email);
  }
}

/// Password strength indicator
class PasswordStrengthHint extends StatelessWidget {
  final String password;

  const PasswordStrengthHint({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _getStrength(context, password);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Column(
        key: ValueKey(strength.level),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Strength bars
          Row(
            children: [
              _StrengthBar(
                isActive: strength.level >= 1,
                color: strength.color,
              ),
              const SizedBox(width: 4),
              _StrengthBar(
                isActive: strength.level >= 2,
                color: strength.color,
              ),
              const SizedBox(width: 4),
              _StrengthBar(
                isActive: strength.level >= 3,
                color: strength.color,
              ),
              const SizedBox(width: 10),
              Text(
                strength.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: strength.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _PasswordStrength _getStrength(BuildContext context, String password) {
    int score = 0;

    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 1) {
      return _PasswordStrength(
        level: 1,
        label: AppLocalizations.of(context)!.passwordWeak,
        color: AppColors.danger,
      );
    } else if (score <= 3) {
      return _PasswordStrength(
        level: 2,
        label: AppLocalizations.of(context)!.passwordMedium,
        color: AppColors.warning,
      );
    } else {
      return _PasswordStrength(
        level: 3,
        label: AppLocalizations.of(context)!.passwordStrong,
        color: AppColors.success,
      );
    }
  }
}

class _PasswordStrength {
  final int level;
  final String label;
  final Color color;

  _PasswordStrength({
    required this.level,
    required this.label,
    required this.color,
  });
}

class _StrengthBar extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _StrengthBar({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? color : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
