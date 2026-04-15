/// Ilova bo'ylab ishlatiladigan global konstantalar.
/// API kalitlarni bu yerga HARDCODE QILMANG!
/// flutter run --dart-define=GEMINI_API_KEY=AIzaSy_... orqali bering.
class AppConstants {
  AppConstants._();

  /// Gemini AI API kaliti (dart-define orqali beriladi).
  /// Xavfsiz usul: flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');
}
