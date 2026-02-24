import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationLog {
  final Map<String, List<String>> taken; // medId: [timesTaken "HH:mm"]
  final DateTime updatedAt;

  MedicationLog({required this.taken, required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {'taken': taken, 'updatedAt': Timestamp.fromDate(updatedAt)};
  }

  factory MedicationLog.fromMap(Map<String, dynamic> map) {
    Map<String, List<String>> takenMap = {};
    if (map['taken'] != null) {
      (map['taken'] as Map<String, dynamic>).forEach((key, value) {
        takenMap[key] = List<String>.from(value);
      });
    }

    return MedicationLog(
      taken: takenMap,
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  /// Defensive DateTime parser — handles all Firestore edge cases:
  /// - Timestamp (normal Firestore)
  /// - int (milliseconds epoch)
  /// - DateTime (local cache)
  /// - null (FieldValue.serverTimestamp() not yet resolved)
  /// - String (ISO 8601 format)
  static DateTime _parseDateTime(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
