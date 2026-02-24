// No imports needed for now

class SymptomAdvice {
  final String message;
  final bool isEmergency;

  SymptomAdvice({required this.message, required this.isEmergency});
}

class SymptomAdviceService {
  static SymptomAdvice getAdvice(List<String> selectedSymptoms, int painLevel) {
    List<String> adviceMessages = [];

    // 1. Shoshilinch belgilar (Emergency check) using internal keys
    if (selectedSymptoms.contains('breathlessness') ||
        selectedSymptoms.contains('chest_pain') ||
        selectedSymptoms.contains('bleeding')) {
      return SymptomAdvice(
        message:
            "DIQQAT: Shoshilinch holat! Zudlik bilan 103 ga qo'ng'iroq qiling yoki eng yaqin shifoxonaga boring.",
        isEmergency: true,
      );
    }

    // 2. Og'riq darajasi bo'yicha
    if (painLevel >= 8) {
      return SymptomAdvice(
        message:
            "Og'riq darajasi juda yuqori ($painLevel/10). Iltimos, shifokor bilan bog'laning.",
        isEmergency: true,
      );
    }

    // 3. Umumiy tavsiyalar
    if (selectedSymptoms.contains('fever')) {
      adviceMessages.add("Ko'proq suyuqlik iching va dam oling.");
    }
    if (selectedSymptoms.contains('headache')) {
      adviceMessages.add(
        "Tinch va qorong'i xonada dam olishga harakat qiling.",
      );
    }
    if (selectedSymptoms.contains('stomachache') ||
        selectedSymptoms.contains('diarrhea')) {
      adviceMessages.add("Yengil ovqatlaning va suv balansini saqlang.");
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
}
