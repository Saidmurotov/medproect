class BmiCalculator {
  /// Calculates BMI given weight in kg and height in cm.
  static double calculate({required double weight, required double heightCm}) {
    if (heightCm <= 0) return 0;
    double heightInMeters = heightCm / 100;
    return weight / (heightInMeters * heightInMeters);
  }
}
