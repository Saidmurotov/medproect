class Validators {
  const Validators._();

  static String? requiredText(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName bo‘sh bo‘lmasligi kerak.';
    }
    return null;
  }
}
