// Unified Symptom Advice Service
// Combines both emergency checks and localized advice into one service

class SymptomAdvice {
  final String message;
  final bool isEmergency;

  SymptomAdvice({required this.message, required this.isEmergency});
}

class SymptomAdviceService {
  /// Emergency symptoms list
  static const List<String> _emergencySymptoms = [
    'breathlessness',
    'chest_pain',
    'bleeding',
  ];

  /// Emergency symptom combinations
  static bool _isEmergencyCombination(List<String> symptoms) {
    final hasFever = symptoms.contains('fever');
    final hasStomachache = symptoms.contains('stomachache');
    final hasDiarrhea = symptoms.contains('diarrhea');

    return (hasFever && hasStomachache) || (hasFever && hasDiarrhea);
  }

  static SymptomAdvice getAdvice(List<String> selectedSymptoms, int painLevel) {
    if (selectedSymptoms.isEmpty) {
      return SymptomAdvice(message: '', isEmergency: false);
    }

    // 1. Emergency symptoms check
    for (final s in selectedSymptoms) {
      if (_emergencySymptoms.contains(s)) {
        return SymptomAdvice(
          message:
              "DIQQAT: Shoshilinch holat! Zudlik bilan 103 ga qo'ng'iroq qiling yoki eng yaqin shifoxonaga boring.",
          isEmergency: true,
        );
      }
    }

    // 2. High pain level check
    if (painLevel >= 8) {
      return SymptomAdvice(
        message:
            "Og'riq darajasi juda yuqori ($painLevel/10). Iltimos, shifokor bilan bog'laning.",
        isEmergency: true,
      );
    }

    // 3. Emergency combinations check
    if (_isEmergencyCombination(selectedSymptoms)) {
      return SymptomAdvice(
        message:
            "⚠️ Bir nechta jiddiy simptomlar aniqlandi. Shifokorga murojaat qilish tavsiya etiladi.",
        isEmergency: true,
      );
    }

    // 4. General advice based on symptoms
    List<String> adviceMessages = [];

    for (final symptom in selectedSymptoms) {
      final advice = _getAdviceForSymptom(symptom);
      if (advice.isNotEmpty && !adviceMessages.contains(advice)) {
        adviceMessages.add(advice);
      }
    }

    if (adviceMessages.isEmpty) {
      return SymptomAdvice(
        message:
            "Ahvolingizni kuzatishda davom eting. Agar belgilar kuchaysa, shifokorga murojaat qiling.",
        isEmergency: false,
      );
    }

    return SymptomAdvice(message: adviceMessages.join(" "), isEmergency: false);
  }

  static String _getAdviceForSymptom(String symptom) {
    switch (symptom) {
      case 'headache':
        return "Tinch va qorong'i xonada dam olishga harakat qiling. Ko'proq suv iching.";
      case 'stomachache':
        return "Yengil ovqatlaning va iliq choy iching.";
      case 'dizziness':
        return "Faollikni kamaytiring va ko'proq dam oling.";
      case 'nausea':
        return "Og'ir ovqatlardan saqlaning va kam-kamdan ovqatlaning.";
      case 'fever':
        return "Ko'proq suyuqlik iching va dam oling. Tana haroratini kuzating.";
      case 'constipation':
        return "Kletchatka va suv iste'molini oshiring.";
      case 'diarrhea':
        return "Yengil ovqatlaning va suv balansini saqlang.";
      case 'belching':
        return "Gazli ichimliklardan saqlaning va sekinroq ovqatlaning.";
      default:
        return '';
    }
  }
}
