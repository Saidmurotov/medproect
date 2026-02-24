import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SymptomAdviceResult {
  final String advice;
  final bool isEmergency;

  SymptomAdviceResult({required this.advice, required this.isEmergency});
}

class SymptomLogicService {
  static SymptomAdviceResult getAdvice({
    required BuildContext context,
    required List<String> selectedSymptoms,
    required int painLevel,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (selectedSymptoms.isEmpty) {
      return SymptomAdviceResult(advice: '', isEmergency: false);
    }

    // 1. Emergency Warning Logic
    final bool hasFever = selectedSymptoms.contains('fever');
    final bool hasStomachache = selectedSymptoms.contains('stomachache');
    final bool hasDiarrhea = selectedSymptoms.contains('diarrhea');

    bool isEmergency =
        painLevel >= 8 ||
        (hasFever && hasStomachache) ||
        (hasFever && hasDiarrhea);

    if (isEmergency) {
      return SymptomAdviceResult(
        advice: l10n.emergencyWarning,
        isEmergency: true,
      );
    }

    // 2. Map Symptoms to Advice Keys
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
        advice = l10n.bmiRecommendation; // Fallback
    }

    return SymptomAdviceResult(advice: advice, isEmergency: false);
  }
}
