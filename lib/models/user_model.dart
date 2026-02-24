import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final double height; // santimetrda
  final double weight; // kilogrammda
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.createdAt,
  });

  // Firestore dan ma'lumot olish uchun
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? 'male',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  // Firestore ga yozish uchun
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // BMI (Tana vazni indeksi) hisoblash
  double get bmi {
    if (height <= 0) return 0;
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  static DateTime _parseDateTime(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }
}
