import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_card.dart';
import '../../l10n/app_localizations.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppColors.softShadow,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
        ),
        title: Text(l10n.monthlySummary, style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    intl.DateFormat.yMMMM(
                      Localizations.localeOf(context).toString(),
                    ).format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2x2 Metric Grid
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.favorite_rounded,
                    iconColor: AppColors.danger,
                    iconBgColor: AppColors.dangerLight,
                    title: l10n.symptomsCount(12).split(' ').first,
                    subtitle: l10n.symptoms,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.speed_rounded,
                    iconColor: AppColors.warning,
                    iconBgColor: AppColors.warningLight,
                    title: '4.3',
                    subtitle: l10n.averagePain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.monitor_weight_outlined,
                    iconColor: AppColors.success,
                    iconBgColor: AppColors.successLight,
                    title: '-1.2 kg',
                    subtitle: l10n.weightChange,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.data_usage_rounded,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primarySurface,
                    title: '-0.6',
                    subtitle: l10n.bmiChange,
                    isPositive: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Improvements section
            Text(l10n.improvements, style: AppTextStyles.h3),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _ImprovementRow(
                    text: l10n.symptomsDecreased,
                    icon: Icons.trending_down_rounded,
                  ),
                  const SizedBox(height: 12),
                  _ImprovementRow(
                    text: l10n.weightDecreased,
                    icon: Icons.fitness_center_rounded,
                  ),
                  const SizedBox(height: 12),
                  _ImprovementRow(
                    text: l10n.bmiImproved,
                    icon: Icons.thumb_up_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.medicalDisclaimer,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool isPositive;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (isPositive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        size: 10,
                        color: AppColors.success,
                      ),
                      Text(
                        ' ${AppLocalizations.of(context)!.goodProgress}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: AppTextStyles.statMedium.copyWith(
              color: isPositive ? AppColors.success : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ImprovementRow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _ImprovementRow({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Icon(icon, size: 20, color: AppColors.success),
        ],
      ),
    );
  }
}
