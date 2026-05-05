import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_card.dart';
import '../../l10n/app_localizations.dart';
import '../../services/firestore_service.dart';
import '../../providers/user_provider.dart';
import '../../models/symptom_model.dart';
import '../../services/pdf_service.dart';
import '../../providers/medication_provider.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
      body: StreamBuilder<List<SymptomModel>>(
        stream: FirestoreService().getSymptoms(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final symptoms = snapshot.data ?? [];
          final currentMonthStats = _calculateStats(symptoms);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
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
                        title: '${currentMonthStats.count}',
                        subtitle: l10n.symptoms,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.speed_rounded,
                        iconColor: AppColors.warning,
                        iconBgColor: AppColors.warningLight,
                        title: currentMonthStats.avgPain.toStringAsFixed(1),
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
                        title: '${user.weight.toStringAsFixed(1)} kg',
                        subtitle: l10n.weight,
                        isPositive: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.data_usage_rounded,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.primarySurface,
                        title: user.bmi.toStringAsFixed(1),
                        subtitle: l10n.bmiTitle,
                        isPositive: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PDF Export Button
                _PdfExportButton(symptoms: symptoms),

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
                        isCompleted: currentMonthStats.count < 10,
                      ),
                      const SizedBox(height: 12),
                      _ImprovementRow(
                        text: l10n.weightDecreased,
                        icon: Icons.fitness_center_rounded,
                        isCompleted: false, // Future
                      ),
                      const SizedBox(height: 12),
                      _ImprovementRow(
                        text: l10n.bmiImproved,
                        icon: Icons.thumb_up_rounded,
                        isCompleted: false, // Future
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
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  _MonthStats _calculateStats(List<SymptomModel> symptoms) {
    final now = DateTime.now();
    final thisMonthSymptoms = symptoms
        .where((s) => s.date.month == now.month && s.date.year == now.year)
        .toList();

    if (thisMonthSymptoms.isEmpty) {
      return _MonthStats(count: 0, avgPain: 0.0);
    }

    final totalPain = thisMonthSymptoms
        .map((s) => s.painLevel)
        .reduce((a, b) => a + b);
    return _MonthStats(
      count: thisMonthSymptoms.length,
      avgPain: totalPain / thisMonthSymptoms.length,
    );
  }
}

class _MonthStats {
  final int count;
  final double avgPain;
  _MonthStats({required this.count, required this.avgPain});
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
  final bool isCompleted;

  const _ImprovementRow({
    required this.text,
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.successLight
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.lock_outline,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isCompleted ? AppColors.textPrimary : Colors.grey,
              ),
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: isCompleted ? AppColors.success : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _PdfExportButton extends StatefulWidget {
  final List<SymptomModel> symptoms;
  const _PdfExportButton({required this.symptoms});

  @override
  State<_PdfExportButton> createState() => _PdfExportButtonState();
}

class _PdfExportButtonState extends State<_PdfExportButton> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isExporting ? null : _exportPdf,
        icon: _isExporting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf_rounded),
        label: Text(_isExporting ? 'Tayyorlanmoqda...' : 'Tarixni PDF yuklash'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.primary),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user!;
      final meds =
          Provider.of<MedicationProvider>(context, listen: false).medications;

      await PdfService().generateAndPrintReport(
        user: user,
        symptoms: widget.symptoms,
        medications: meds,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xato: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
