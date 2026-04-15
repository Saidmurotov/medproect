import 'package:cloud_firestore/cloud_firestore.dart';

/// Gemini qaytargan ovqat tahlili natijasini saqlash uchun model.
class FoodResultModel {
  final bool isFood;
  final String? foodName;
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  final String? portion;
  final String message;

  FoodResultModel({
    required this.isFood,
    this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.portion,
    required this.message,
  });

  /// Gemini JSON javobidan model yaratish.
  factory FoodResultModel.fromJson(Map<String, dynamic> json) {
    return FoodResultModel(
      isFood: json['is_food'] as bool? ?? false,
      foodName: json['food_name'] as String?,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      portion: json['portion'] as String?,
      message: json['message'] as String? ?? '',
    );
  }

  /// Firestore ga yozish uchun Map ga o'girish.
  Map<String, dynamic> toFirestore(String userId) {
    return {
      'userId': userId,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'portion': portion,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
