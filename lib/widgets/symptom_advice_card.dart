import 'package:flutter/material.dart';
import '../models/symptom_model.dart';
import '../services/symptom_logic_service.dart';
import '../l10n/app_localizations.dart';

class SymptomAdviceCard extends StatelessWidget {
  final SymptomModel latestSymptom;

  const SymptomAdviceCard({super.key, required this.latestSymptom});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 1. Get dynamic advice using the service
    final result = SymptomLogicService.getAdvice(
      context: context,
      selectedSymptoms: latestSymptom.symptoms,
      painLevel: latestSymptom.painLevel,
    );

    // 2. Define colors based on emergency status
    final Color bgColor = result.isEmergency
        ? const Color(0xFFFFE5E5)
        : const Color(0xFFE8F5E9);
    final Color contentColor = result.isEmergency
        ? const Color(0xFF991B1B)
        : const Color(0xFF166534);
    final IconData icon = result.isEmergency
        ? Icons.warning_amber_rounded
        : Icons.lightbulb_outline_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: contentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: contentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: contentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.isEmergency ? l10n.emergencyTitle : l10n.adviceTitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: contentColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.advice,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
