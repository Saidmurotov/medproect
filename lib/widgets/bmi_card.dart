import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';
import '../l10n/app_localizations.dart';

class BmiCard extends StatelessWidget {
  final double bmi;

  const BmiCard({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (String category, String helper, Color color, Color bgColor) =
        _getBmiInfo(l10n);
    final double progress = (bmi / 40).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: title + status badge
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.bmiTitle, style: AppTextStyles.bodyMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Big BMI number with label
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${l10n.yourBmiLabel}: ', style: AppTextStyles.bodyMedium),
              Text(
                bmi.toStringAsFixed(1),
                style: AppTextStyles.statLarge.copyWith(color: color),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Helper subtitle
          Text(
            helper,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: color.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 20),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF22C55E), // Normal
                          Color(0xFFF59E0B), // Overweight
                          Color(0xFFEF4444), // Obesity
                        ],
                      ),
                    ),
                  ),
                  // Progress indicator dot
                  Positioned(
                    left:
                        (MediaQuery.of(context).size.width - 88) * progress - 4,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Scale labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15', style: AppTextStyles.bodySmall),
              Text('25', style: AppTextStyles.bodySmall),
              Text('30', style: AppTextStyles.bodySmall),
              Text('40', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  (String, String, Color, Color) _getBmiInfo(AppLocalizations l10n) {
    if (bmi < 18.5) {
      return (
        l10n.bmiUnderweight,
        l10n.bmiHelperUnderweight,
        AppColors.warning,
        AppColors.warningLight,
      );
    } else if (bmi < 25) {
      return (
        l10n.bmiNormal,
        l10n.bmiHelperNormal,
        AppColors.success,
        AppColors.successLight,
      );
    } else if (bmi < 30) {
      return (
        l10n.bmiOverweight,
        l10n.bmiHelperOverweight,
        AppColors.warning,
        AppColors.warningLight,
      );
    } else {
      return (
        l10n.bmiObese,
        l10n.bmiHelperObese,
        AppColors.danger,
        AppColors.dangerLight,
      );
    }
  }
}
