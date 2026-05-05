import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomModel {
  final String id;
  final String userId;
  final List<String> symptoms; // Tanlangan simptomlar ro'yxati
  final int painLevel; // Og'riq darajasi (1-10)
  final String? note;
  final DateTime date;

  SymptomModel({
    required this.id,
    required this.userId,
    required this.symptoms,
    required this.painLevel,
    this.note,
    required this.date,
  });

  factory SymptomModel.fromMap(String id, Map<String, dynamic> map) {
    return SymptomModel(
      id: id,
      userId: map['userId'] ?? '',
      symptoms: List<String>.from(map['symptoms'] ?? []),
      painLevel: map['painLevel'] ?? 0,
      note: map['note'] as String?,
      date: _parseDateTime(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'symptoms': symptoms,
      'painLevel': painLevel,
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      'date': Timestamp.fromDate(date),
    };
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
