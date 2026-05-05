import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;
  StreamSubscription<User?>? _authSubscription;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Listen to Firebase Auth state changes
    _authSubscription = _authService.user.listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<User?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final signedInUser = await _authService.signIn(email, password);
      _user = signedInUser;
      return signedInUser;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required double height,
    required double weight,
    required String diagnosis,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final registeredUser = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        diagnosis: diagnosis,
      );
      _user = registeredUser;
      return registeredUser;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
