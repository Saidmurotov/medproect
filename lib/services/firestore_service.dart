import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/symptom_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Foydalanuvchi ma'lumotlarini saqlash
  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      debugPrint("⚠️ saveUser failed (will sync when online): $e");
      // Firestore queues the write if persistence is enabled
    }
  }

  // Foydalanuvchi ma'lumotlarini olish (offline-safe)
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(userId)
          .get(const GetOptions(source: Source.cache));
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
    } catch (_) {
      // Cache miss — try server
    }

    // Fallback to server
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
    } catch (e) {
      debugPrint("⚠️ getUser failed (offline, no cache): $e");
    }
    return null;
  }

  // Simptomni saqlash
  Future<void> addSymptom(SymptomModel symptom) async {
    try {
      await _db.collection('symptoms').add(symptom.toMap());
    } catch (e) {
      debugPrint("⚠️ addSymptom failed: $e");
      rethrow;
    }
  }

  // Simptomlarni olish
  Stream<List<SymptomModel>> getSymptoms(String userId) {
    return _db
        .collection('symptoms')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SymptomModel.fromMap(doc.id, doc.data()))
              .toList(),
        )
        .handleError((e) {
          debugPrint("⚠️ getSymptoms stream error: $e");
          return <SymptomModel>[];
        });
  }

  /// Bugungi jami kaloriyani hisoblash (Real-time)
  Stream<int> getTodayTotalCalories(String userId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _db
        .collection('foodLogs')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(todayEnd))
        .snapshots()
        .map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['calories'] as num?)?.toInt() ?? 0;
      }
      return total;
    });
  }
}
