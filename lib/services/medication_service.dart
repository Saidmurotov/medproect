import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/medication_model.dart';
import '../models/medication_log_model.dart';

class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Medications CRUD
  Stream<List<Medication>> getMedications() {
    if (_uid == null) return Stream.value([]);
    return _firestore
        .collection('medications')
        .doc(_uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return Medication.fromMap(doc.data());
                } catch (e) {
                  debugPrint("⚠️ Failed to parse medication ${doc.id}: $e");
                  return null;
                }
              })
              .whereType<Medication>()
              .toList(),
        )
        .handleError((e) {
          debugPrint("⚠️ getMedications stream error: $e");
          return <Medication>[];
        });
  }

  Future<void> addMedication(Medication medication) async {
    if (_uid == null) throw Exception("User not authenticated");
    try {
      await _firestore
          .collection('medications')
          .doc(_uid)
          .collection('items')
          .doc(medication.id)
          .set(medication.toMap());
    } catch (e) {
      debugPrint("⚠️ addMedication failed (queued if offline): $e");
      rethrow;
    }
  }

  Future<void> updateMedication(Medication medication) async {
    if (_uid == null) throw Exception("User not authenticated");
    try {
      await _firestore
          .collection('medications')
          .doc(_uid)
          .collection('items')
          .doc(medication.id)
          .update(medication.toMap());
    } catch (e) {
      debugPrint("⚠️ updateMedication failed: $e");
      rethrow;
    }
  }

  Future<void> deleteMedication(String medId) async {
    if (_uid == null) return;
    try {
      await _firestore
          .collection('medications')
          .doc(_uid)
          .collection('items')
          .doc(medId)
          .delete();
    } catch (e) {
      debugPrint("⚠️ deleteMedication failed: $e");
    }
  }

  // Medication Logs
  Stream<MedicationLog?> getLogForDate(String dateStr) {
    if (_uid == null) return Stream.value(null);
    return _firestore
        .collection('medicationLogs')
        .doc(_uid)
        .collection('days')
        .doc(dateStr)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          try {
            return MedicationLog.fromMap(doc.data()!);
          } catch (e) {
            debugPrint("⚠️ Failed to parse medication log: $e");
            return null;
          }
        })
        .handleError((e) {
          debugPrint("⚠️ getLogForDate stream error: $e");
          return null;
        });
  }

  Future<void> logMedication(
    String dateStr,
    String medId,
    String time,
    bool taken,
  ) async {
    if (_uid == null) return;
    final docRef = _firestore
        .collection('medicationLogs')
        .doc(_uid)
        .collection('days')
        .doc(dateStr);

    try {
      final doc = await docRef.get();
      MedicationLog log;

      if (doc.exists) {
        log = MedicationLog.fromMap(doc.data()!);
        final currentTimes = log.taken[medId] ?? [];
        if (taken) {
          if (!currentTimes.contains(time)) {
            currentTimes.add(time);
          }
        } else {
          currentTimes.remove(time);
        }
        log.taken[medId] = currentTimes;
      } else {
        log = MedicationLog(
          taken: taken
              ? {
                  medId: [time],
                }
              : {},
          updatedAt: DateTime.now(),
        );
      }

      await docRef.set({
        'taken': log.taken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("⚠️ logMedication failed: $e");
      rethrow;
    }
  }
}
