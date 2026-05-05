import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUser(UserModel? user) {
    if (_user?.id == user?.id && _error == null) return;
    _user = user;
    _error = null;
    notifyListeners();
  }

  void initialize(String userId) {
    loadUser(userId);
  }

  // Foydalanuvchi ma'lumotlarini yuklash (offline-safe)
  Future<void> loadUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _firestoreService.getUser(userId);
      if (userData != null) {
        _user = userData;
      } else {
        debugPrint("⚠️ User data not found for: $userId");
        _error = "User data not found";
      }
    } catch (e) {
      debugPrint("⚠️ loadUser failed: $e");
      _error = e.toString();
      // Don't clear _user — keep any previously loaded data
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
