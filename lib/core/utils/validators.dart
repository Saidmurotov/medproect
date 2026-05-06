class Validators {
  const Validators._();

  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName bo\'sh bo\'lmasligi kerak.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredText(value, 'Email');
    if (requiredError != null) return requiredError;

    final email = value!.trim();
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email)) {
      return 'Email manzil noto\'g\'ri kiritilgan.';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredText(value, 'Parol');
    if (requiredError != null) return requiredError;

    if (value!.length < 6) {
      return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak.';
    }
    return null;
  }

  static String? positiveInt(String? value, String fieldName) {
    final requiredError = requiredText(value, fieldName);
    if (requiredError != null) return requiredError;

    final parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return '$fieldName musbat butun son bo\'lishi kerak.';
    }
    return null;
  }

  static String? positiveDouble(String? value, String fieldName) {
    final requiredError = requiredText(value, fieldName);
    if (requiredError != null) return requiredError;

    final parsed = double.tryParse(value!.trim().replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return '$fieldName musbat son bo\'lishi kerak.';
    }
    return null;
  }
}
