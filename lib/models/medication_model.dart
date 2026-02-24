import 'package:cloud_firestore/cloud_firestore.dart';

enum ScheduleType { daily, custom, prn }

class Medication {
  final String id;
  final String name;
  final String? dose;
  final ScheduleType scheduleType;
  final List<String> times; // Format: "HH:mm"
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final bool reminderEnabled;
  final DateTime createdAt;

  Medication({
    required this.id,
    required this.name,
    this.dose,
    required this.scheduleType,
    required this.times,
    required this.daysOfWeek,
    required this.reminderEnabled,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'scheduleType': scheduleType.name,
      'times': times,
      'daysOfWeek': daysOfWeek,
      'reminderEnabled': reminderEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dose: map['dose'],
      scheduleType: ScheduleType.values.firstWhere(
        (e) => e.name == map['scheduleType'],
        orElse: () => ScheduleType.daily,
      ),
      times: List<String>.from(map['times'] ?? []),
      daysOfWeek: List<int>.from(map['daysOfWeek'] ?? []),
      reminderEnabled: map['reminderEnabled'] ?? false,
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  Medication copyWith({
    String? name,
    String? dose,
    ScheduleType? scheduleType,
    List<String>? times,
    List<int>? daysOfWeek,
    bool? reminderEnabled,
  }) {
    return Medication(
      id: id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      scheduleType: scheduleType ?? this.scheduleType,
      times: times ?? this.times,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      createdAt: createdAt,
    );
  }

  /// Defensive DateTime parser — handles Firestore Timestamp, int, DateTime, String, null
  static DateTime _parseDateTime(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }
}
