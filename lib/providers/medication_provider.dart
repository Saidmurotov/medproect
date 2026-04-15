import 'dart:async';
import 'package:flutter/material.dart';
import '../models/medication_model.dart';
import '../models/medication_log_model.dart';
import '../services/medication_service.dart';
import '../services/notification_service.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationService _service = MedicationService();
  final NotificationService _notificationService = NotificationService();

  List<Medication> _medications = [];
  MedicationLog? _todayLog;
  final List<StreamSubscription> _subscriptions = [];
  bool _isLoading = false;
  String? _lastError;

  List<Medication> get medications => _medications;
  MedicationLog? get todayLog => _todayLog;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  void init() {
    _cancelSubscriptions();

    // 1. Listen to medications stream
    final medsSub = _service.getMedications().listen(
      (meds) {
        _medications = meds;
        _lastError = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint("⚠️ Medications stream error: $e");
        _lastError = e.toString();
        notifyListeners();
      },
    );
    _subscriptions.add(medsSub);

    // 2. Listen to today's intake logs
    final dateStr = DateTime.now().toIso8601String().split('T')[0];
    final logSub = _service.getLogForDate(dateStr).listen((log) {
      _todayLog = log;
      notifyListeners();
    });
    _subscriptions.add(logSub);
  }

  void _cancelSubscriptions() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }

  Future<void> addMedication(Medication med) async {
    // 0. Ensure permissions are granted FIRST
    try {
      final allGranted = await _notificationService
          .requestPermissionsIfNeeded();
      debugPrint("🔐 Permissions granted: $allGranted");
    } catch (e) {
      debugPrint("⚠️ Permission request error: $e");
    }

    // 1. Schedule LOCAL notification using new service methods
    try {
      await _scheduleLocalNotifications(med);
      debugPrint("✅ Notification scheduled for: ${med.name}");

      // Verify that it was actually scheduled
      final pending = await _notificationService.getPendingNotifications();
      debugPrint("📋 Total pending after add: ${pending.length}");
    } catch (e) {
      debugPrint("⚠️ Local notification scheduling failed: $e");
    }

    // 2. Sync with Firestore (may fail offline — Firestore queues it)
    try {
      _isLoading = true;
      notifyListeners();
      await _service.addMedication(med);
    } catch (e) {
      debugPrint("⚠️ Firestore addition failed (will sync later): $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedication(Medication med) async {
    // 1. Update LOCAL notifications first
    try {
      await _scheduleLocalNotifications(med);
    } catch (e) {
      debugPrint("⚠️ Local notification update failed: $e");
    }

    // 2. Sync with Firestore
    try {
      _isLoading = true;
      notifyListeners();
      await _service.updateMedication(med);
    } catch (e) {
      debugPrint("⚠️ Firestore update failed: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(String medId) async {
    try {
      // Cancel notifications for this medication
      final baseId = _generateIntId(medId);
      // We cancel all possible IDs generated for this medication
      for (int i = 0; i < 70; i++) {
        await _notificationService.cancelMedicationReminder(baseId * 70 + i);
      }
      // Also cancel the base IDs
      await _notificationService.cancelMedicationReminder(baseId);

      await _service.deleteMedication(medId);
    } catch (e) {
      debugPrint("⚠️ Delete failed: $e");
    }
  }

  /// Helper to map Medication model to new NotificationService API
  Future<void> _scheduleLocalNotifications(Medication med) async {
    final baseId = _generateIntId(med.id);

    // Cancel existing first (to avoid duplicates or outdated times)
    for (int i = 0; i < 70; i++) {
      await _notificationService.cancelMedicationReminder(baseId * 70 + i);
    }
    await _notificationService.cancelMedicationReminder(baseId);

    if (!med.reminderEnabled || med.scheduleType == ScheduleType.prn) return;

    for (int i = 0; i < med.times.length; i++) {
      final timeParts = med.times[i].split(':');
      final timeOfDay = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );

      final specificId = baseId * 70 + (i * 10);

      if (med.scheduleType == ScheduleType.daily) {
        await _notificationService.scheduleMedicationReminder(
          id: specificId,
          medicationName: med.name,
          dosage: med.dose ?? '',
          time: timeOfDay,
        );
      } else if (med.scheduleType == ScheduleType.custom) {
        await _notificationService.scheduleMedicationReminderForDays(
          baseId: specificId,
          medicationName: med.name,
          dosage: med.dose ?? '',
          time: timeOfDay,
          daysOfWeek: med.daysOfWeek,
        );
      }
    }
  }

  int _generateIntId(String medId) {
    return medId.hashCode.abs() % 100000;
  }

  /// Request notification permissions from UI
  Future<void> requestPermissions() async {
    await _notificationService.requestPermissionsIfNeeded();
  }

  bool isTaken(String medId, String time) {
    if (_todayLog == null) return false;
    final takenTimes = _todayLog!.taken[medId];
    return takenTimes != null && takenTimes.contains(time);
  }

  Future<void> toggleTaken(String medId, String time, bool taken) async {
    try {
      final dateStr = DateTime.now().toIso8601String().split('T')[0];
      await _service.logMedication(dateStr, medId, time, taken);
      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Toggle taken failed: $e");
      notifyListeners();
    }
  }
}
