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
  bool _isLoading = false;
  String? _lastError;

  List<Medication> get medications => _medications;
  MedicationLog? get todayLog => _todayLog;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  void init() {
    // 1. Listen to medications stream
    _service.getMedications().listen(
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

    // 2. Listen to today's intake logs
    final dateStr = DateTime.now().toIso8601String().split('T')[0];
    _service.getLogForDate(dateStr).listen((log) {
      _todayLog = log;
      notifyListeners();
    });
  }

  Future<void> addMedication(Medication med) async {
    // 1. Schedule LOCAL notification FIRST (works offline, stable)
    try {
      await _notificationService.scheduleMedicationNotification(med);
      debugPrint("✅ Notification scheduled for: ${med.name}");
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
      await _notificationService.scheduleMedicationNotification(med);
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
      await _notificationService.cancelMedicationNotification(medId);
      await _service.deleteMedication(medId);
    } catch (e) {
      debugPrint("⚠️ Delete failed: $e");
    }
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
