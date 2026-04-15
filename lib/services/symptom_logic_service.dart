import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SymptomAdviceResult {
  final String advice;
  final bool isEmergency;

  SymptomAdviceResult({required this.advice, required this.isEmergency});
}

/// Localized version of symptom advice service
/// Used by SymptomAdviceCard widget for displaying localized advice
class SymptomLogicService {
  /// Emergency symptoms list
  static const List<String> _emergencySymptoms = [
    'breathlessness',
    'chest_pain',
    'bleeding',
  ];

  static SymptomAdviceResult getAdvice({
    required BuildContext context,
    required List<String> selectedSymptoms,
    required int painLevel,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (selectedSymptoms.isEmpty) {
      return SymptomAdviceResult(advice: '', isEmergency: false);
    }

    // 1. Emergency symptom check
    for (final s in selectedSymptoms) {
      if (_emergencySymptoms.contains(s)) {
        return SymptomAdviceResult(
          advice: l10n.emergencyWarning,
          isEmergency: true,
        );
      }
    }

    // 2. High pain check
    if (painLevel >= 8) {
      return SymptomAdviceResult(
        advice: l10n.emergencyWarning,
        isEmergency: true,
      );
    }

    // 3. Emergency combinations
    final bool hasFever = selectedSymptoms.contains('fever');
    final bool hasStomachache = selectedSymptoms.contains('stomachache');
    final bool hasDiarrhea = selectedSymptoms.contains('diarrhea');

    if ((hasFever && hasStomachache) || (hasFever && hasDiarrhea)) {
      return SymptomAdviceResult(
        advice: l10n.emergencyWarning,
        isEmergency: true,
      );
    }

    // 4. Localized advice for first symptom
    final String firstSymptom = selectedSymptoms.first;
    String advice = '';

    switch (firstSymptom) {
      case 'headache':
        advice = l10n.adviceHeadache;
        break;
      case 'stomachache':
        advice = l10n.adviceStomachache;
        break;
      case 'dizziness':
        advice = l10n.adviceDizziness;
        break;
      case 'nausea':
        advice = l10n.adviceNausea;
        break;
      case 'fever':
        advice = l10n.adviceFever;
        break;
      case 'constipation':
        advice = l10n.adviceConstipation;
        break;
      case 'diarrhea':
        advice = l10n.adviceDiarrhea;
        break;
      case 'belching':
        advice = l10n.adviceBelching;
        break;
      default:
        advice = l10n.bmiRecommendation;
    }

    return SymptomAdviceResult(advice: advice, isEmergency: false);
  }
}
