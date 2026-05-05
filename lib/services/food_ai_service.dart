import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class FoodAiService {
  // Mahalliy (offline) kaloriya bazasi
  static final Map<String, Map<String, dynamic>> _foodDatabase = {
    'apple': {
      'calories': 52,
      'protein': 0,
      'fat': 0,
      'carbs': 14,
      'name': 'Olma',
    },
    'banana': {
      'calories': 89,
      'protein': 1,
      'fat': 0,
      'carbs': 23,
      'name': 'Banan',
    },
    'pizza': {
      'calories': 266,
      'protein': 11,
      'fat': 10,
      'carbs': 33,
      'name': 'Pitsa',
    },
    'hamburger': {
      'calories': 295,
      'protein': 14,
      'fat': 14,
      'carbs': 24,
      'name': 'Gamburger',
    },
    'fries': {
      'calories': 312,
      'protein': 3,
      'fat': 15,
      'carbs': 41,
      'name': 'Kartoshka fri',
    },
    'salad': {
      'calories': 150,
      'protein': 5,
      'fat': 7,
      'carbs': 10,
      'name': 'Salat',
    },
    'bread': {
      'calories': 265,
      'protein': 9,
      'fat': 3,
      'carbs': 49,
      'name': 'Non',
    },
    'meat': {
      'calories': 250,
      'protein': 26,
      'fat': 15,
      'carbs': 0,
      'name': 'Go\'sht',
    },
    'chicken': {
      'calories': 239,
      'protein': 27,
      'fat': 14,
      'carbs': 0,
      'name': 'Tovuq',
    },
    'fish': {
      'calories': 206,
      'protein': 22,
      'fat': 12,
      'carbs': 0,
      'name': 'Baliq',
    },
    'rice': {
      'calories': 130,
      'protein': 2,
      'fat': 0,
      'carbs': 28,
      'name': 'Guruch',
    },
    'egg': {
      'calories': 155,
      'protein': 13,
      'fat': 11,
      'carbs': 1,
      'name': 'Tuxum',
    },
    'milk': {'calories': 42, 'protein': 3, 'fat': 1, 'carbs': 5, 'name': 'Sut'},
    'fruit': {
      'calories': 60,
      'protein': 1,
      'fat': 0,
      'carbs': 15,
      'name': 'Meva',
    },
    'vegetable': {
      'calories': 25,
      'protein': 1,
      'fat': 0,
      'carbs': 5,
      'name': 'Sabzavot',
    },
    'food': {
      'calories': 200,
      'protein': 10,
      'fat': 10,
      'carbs': 20,
      'name': 'Umumiy ovqat',
    },
    'cake': {
      'calories': 350,
      'protein': 4,
      'fat': 15,
      'carbs': 50,
      'name': 'Tort/Pirojniy',
    },
    'soup': {
      'calories': 90,
      'protein': 4,
      'fat': 3,
      'carbs': 10,
      'name': 'Sho\'rva',
    },
    'drink': {
      'calories': 45,
      'protein': 0,
      'fat': 0,
      'carbs': 11,
      'name': 'Ichimlik',
    },
  };

  static Future<Map<String, dynamic>> analyzeFood(File imageFile) async {
    try {
      debugPrint('AI: Google ML Kit (Offline) orqali tahlil boshlandi...');

      final inputImage = InputImage.fromFile(imageFile);

      final ImageLabelerOptions options = ImageLabelerOptions(
        confidenceThreshold: 0.5,
      );
      final imageLabeler = ImageLabeler(options: options);

      final List<ImageLabel> labels = await imageLabeler.processImage(
        inputImage,
      );
      imageLabeler.close(); // Resurslarni bo'shatish

      if (labels.isEmpty) {
        return {
          "is_food": false,
          "message": "Rasmda hech qanday obyekt aniqlanmadi.",
        };
      }

      // Eng katta ehtimolligi bor nomlarni tekshiramiz
      for (ImageLabel label in labels) {
        final String text = label.label.toLowerCase();
        final double confidence = label.confidence;
        debugPrint(
          "ML Kit topdi: $text (ishonch: ${(confidence * 100).toStringAsFixed(1)}%)",
        );

        // Baza ichidan qidiramiz
        for (var key in _foodDatabase.keys) {
          if (text.contains(key)) {
            final foodData = _foodDatabase[key]!;
            return {
              "is_food": true,
              "food_name": foodData['name'],
              "calories": foodData['calories'],
              "protein": foodData['protein'],
              "fat": foodData['fat'],
              "carbs": foodData['carbs'],
              "portion": "1 porsiya",
              "message": "Muvaffaqiyatli aniqlandi",
            };
          }
        }
      }

      // Agar aniq nom topilmasa, rasmda kamida "ovqatlik" asari borligini tekshiramiz
      for (ImageLabel label in labels) {
        final String text = label.label.toLowerCase();
        if (text.contains("food") ||
            text.contains("meal") ||
            text.contains("dish") ||
            text.contains("cuisine") ||
            text.contains("produce") ||
            text.contains("plate") ||
            text.contains("snack")) {
          return {
            "is_food": true,
            "food_name": "Ovqat (${label.label})",
            "calories": 250,
            "protein": 10,
            "fat": 10,
            "carbs": 25,
            "portion": "O'rtacha 1 porsiya",
            "message":
                "Ovqat nomi noaniq bo'lgani uchun o'rtacha qiymatlar olindi.",
          };
        }
      }

      return {
        "is_food": false,
        "message": "Bu rasmda aniq bir ovqat turini taniy olmadim.",
      };
    } catch (e) {
      debugPrint('ML Kit Xato: $e');
      return {
        "is_food": false,
        "message": "Tahlil jarayonida xatolik yuz berdi: $e",
      };
    }
  }
}
